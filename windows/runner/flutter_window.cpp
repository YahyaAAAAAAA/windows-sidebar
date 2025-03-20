//disable Visual Studio warnings for sprintf
#define _CRT_SECURE_NO_WARNINGS

#include "flutter_window.h"
#include <optional>
#include "flutter/generated_plugin_registrant.h"

#include <flutter/binary_messenger.h>
#include <flutter/standard_method_codec.h>
#include <flutter/method_channel.h>
#include <flutter/method_result_functions.h>

#include <windows.h>
#include <shlobj.h>
#include <shlwapi.h>
#include <vector>
#include <iostream>
#include <string>

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#pragma comment(lib, "dwmapi.lib")

using namespace std;

// Blur effect structs
typedef struct _ACCENT_POLICY {
  int nAccentState;
  int nFlags;
  int nColor;
  int nAnimationId;
} ACCENT_POLICY;

typedef struct _WINDOWCOMPOSITIONATTRIBDATA {
  int nAttribute;
  PVOID pData;
  SIZE_T ulDataSize;
} WINDOWCOMPOSITIONATTRIBDATA;

enum AccentState {
  ACCENT_DISABLED = 0,
  ACCENT_ENABLE_BLURBEHIND = 3,
};

enum WindowCompositionAttribute {
  WCA_ACCENT_POLICY = 19,
};

//convert std::string to std::wstring
std::wstring StringToWString(const std::string& str) {
  int size_needed = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, NULL, 0);
  std::wstring wstr(size_needed, 0);
  MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, &wstr[0], size_needed);
  return wstr;
}

bool GetFileIcon(const std::string& filePath, std::vector<uint8_t>& pngBytes) {
    SHFILEINFO shFileInfo;
    std::wstring wideFilePath = StringToWString(filePath);

    if (SHGetFileInfo(wideFilePath.c_str(), 0, &shFileInfo, sizeof(SHFILEINFO), SHGFI_ICON | SHGFI_LARGEICON) == 0) {
        return false; 
    }

    ICONINFO iconInfo;
    if (!GetIconInfo(shFileInfo.hIcon, &iconInfo)) {
        DestroyIcon(shFileInfo.hIcon);
        return false;
    }

    BITMAP bmp;
    if (GetObject(iconInfo.hbmColor, sizeof(BITMAP), &bmp) == 0) {
        DestroyIcon(shFileInfo.hIcon);
        DeleteObject(iconInfo.hbmColor);
        if (iconInfo.hbmMask) DeleteObject(iconInfo.hbmMask);
        return false;
    }

    int width = bmp.bmWidth;
    int height = bmp.bmHeight;
    int pixelSize = 4; 
    std::vector<uint8_t> rawBitmapData(width * height * pixelSize);

    HDC hdcScreen = GetDC(NULL);
    HDC hdcMem = CreateCompatibleDC(hdcScreen);
    HBITMAP hbmOld = (HBITMAP)SelectObject(hdcMem, iconInfo.hbmColor);

    BITMAPINFO bmi = {0};
    bmi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bmi.bmiHeader.biWidth = width;
    bmi.bmiHeader.biHeight = -height;
    bmi.bmiHeader.biPlanes = 1;
    bmi.bmiHeader.biBitCount = 32;
    bmi.bmiHeader.biCompression = BI_RGB;

    if (GetDIBits(hdcMem, iconInfo.hbmColor, 0, height, rawBitmapData.data(), &bmi, DIB_RGB_COLORS) == 0) {
        SelectObject(hdcMem, hbmOld);
        DeleteDC(hdcMem);
        ReleaseDC(NULL, hdcScreen);
        DestroyIcon(shFileInfo.hIcon);
        DeleteObject(iconInfo.hbmColor);
        if (iconInfo.hbmMask) DeleteObject(iconInfo.hbmMask);
        return false;
    }

    SelectObject(hdcMem, hbmOld);
    DeleteDC(hdcMem);
    ReleaseDC(NULL, hdcScreen);

    for (int i = 0; i < width * height; i++) {
        std::swap(rawBitmapData[i * 4], rawBitmapData[i * 4 + 2]);
    }

    int pngSize;
    unsigned char* pngData = stbi_write_png_to_mem(rawBitmapData.data(), width * 4, width, height, 4, &pngSize);
    if (pngSize <= 0) {
        DestroyIcon(shFileInfo.hIcon);
        DeleteObject(iconInfo.hbmColor);
        if (iconInfo.hbmMask) DeleteObject(iconInfo.hbmMask);
        return false;
    }

    pngBytes.assign(pngData, pngData + pngSize);
    free(pngData);

    DestroyIcon(shFileInfo.hIcon);
    DeleteObject(iconInfo.hbmColor);
    if (iconInfo.hbmMask) DeleteObject(iconInfo.hbmMask);

    return true;
}

void ApplyBlurEffect(HWND hwnd) {
   // Dynamically load SetWindowCompositionAttribute
   HMODULE hUser = LoadLibraryA("user32.dll");
   if (hUser) {
     typedef BOOL(WINAPI *pSetWindowCompositionAttribute)(HWND, WINDOWCOMPOSITIONATTRIBDATA*);
     auto SetWindowCompositionAttributeFunc = (pSetWindowCompositionAttribute)GetProcAddress(hUser, "SetWindowCompositionAttribute");
 
     if (SetWindowCompositionAttributeFunc) {
       ACCENT_POLICY policy = { ACCENT_ENABLE_BLURBEHIND, 0, 0, 0 };
       WINDOWCOMPOSITIONATTRIBDATA data = { WCA_ACCENT_POLICY, &policy, sizeof(policy) };
       SetWindowCompositionAttributeFunc(hwnd, &data);
     }
     FreeLibrary(hUser);
   }
}

void initMethodChannel(flutter::FlutterEngine* flutter_instance) {
    const static std::string channel_name("file_icon_channel");

    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            flutter_instance->messenger(), channel_name,
            &flutter::StandardMethodCodec::GetInstance());

    channel->SetMethodCallHandler(
        [flutter_instance](const flutter::MethodCall<flutter::EncodableValue>& call, 
           std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

            if (call.method_name().compare("getFileIcon") == 0) {
                std::string filePath;
                if (call.arguments() && std::holds_alternative<std::string>(*call.arguments())) {
                    filePath = std::get<std::string>(*call.arguments());
                } else {
                    result->Error("INVALID_ARGUMENT", "Expected a file path string.");
                    return;
                }

                std::vector<uint8_t> pngBytes;
                if (GetFileIcon(filePath, pngBytes)) {
                    result->Success(flutter::EncodableValue(pngBytes));
                } else {
                    result->Error("ICON_RETRIEVAL_FAILED", "Could not retrieve file icon.");
                }
            } else if (call.method_name().compare("applyBlur") == 0) {
                HWND hwnd = GetActiveWindow();

                if (hwnd) {
                    ApplyBlurEffect(hwnd);
                    result->Success();
                } else {
                    result->Error("HWND_NOT_FOUND", "Could not retrieve window handle.");
                }
            } else {
                result->NotImplemented();
            }
        });
}

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}

bool FlutterWindow::OnCreate() {
    if (!Win32Window::OnCreate()) {
        return false;
    }

    RECT frame = GetClientArea();

    flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
        frame.right - frame.left, frame.bottom - frame.top, project_);
    
    if (!flutter_controller_->engine() || !flutter_controller_->view()) {
        return false;
    }

    RegisterPlugins(flutter_controller_->engine());
    
    initMethodChannel(flutter_controller_->engine());

    SetChildContent(flutter_controller_->view()->GetNativeWindow());

    flutter_controller_->engine()->SetNextFrameCallback([&]() {
        this->Show();
    });

    flutter_controller_->ForceRedraw();

    return true;
}

void FlutterWindow::OnDestroy() {
    if (flutter_controller_) {
        flutter_controller_ = nullptr;
    }

    Win32Window::OnDestroy();
}

LRESULT FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                                      WPARAM const wparam,
                                      LPARAM const lparam) noexcept {
    if (flutter_controller_) {
        std::optional<LRESULT> result =
            flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                          lparam);
        if (result) {
            return *result;
        }
    }

    switch (message) {
        case WM_FONTCHANGE:
            flutter_controller_->engine()->ReloadSystemFonts();
            break;
    }

    return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
