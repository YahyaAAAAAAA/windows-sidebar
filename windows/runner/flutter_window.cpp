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
#include <dwmapi.h>
#include <shlobj.h>
#include <shlwapi.h>
#include <vector>
#include <iostream>
#include <string>
#include <VersionHelpers.h>
#include <winternl.h>  // Added for NTSTATUS

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

// Define NT_SUCCESS macro
#ifndef NT_SUCCESS
#define NT_SUCCESS(Status) (((NTSTATUS)(Status)) >= 0)
#endif

// Windows 11 constants (if not available in SDK)
#ifndef DWMWA_SYSTEMBACKDROP_TYPE
#define DWMWA_SYSTEMBACKDROP_TYPE 38
#endif

#ifndef DWMWA_USE_IMMERSIVE_DARK_MODE
#define DWMWA_USE_IMMERSIVE_DARK_MODE 20
#endif

#ifndef DWMWA_WINDOW_CORNER_PREFERENCE  
#define DWMWA_WINDOW_CORNER_PREFERENCE 33
#endif

#ifndef DWMWCP_ROUND
#define DWMWCP_ROUND 2
#endif

#pragma comment(lib, "dwmapi.lib")
#pragma comment(lib, "version.lib")

using namespace std;

enum ACCENT_STATE {
    ACCENT_DISABLED = 0,
    ACCENT_ENABLE_GRADIENT = 1,
    ACCENT_ENABLE_TRANSPARENTGRADIENT = 2,
    ACCENT_ENABLE_BLURBEHIND = 3,
    ACCENT_ENABLE_ACRYLICBLURBEHIND = 4,    // Windows 10 Acrylic
    ACCENT_ENABLE_HOSTBACKDROP = 5,         // Windows 11 Mica/Acrylic
    ACCENT_INVALID_STATE = 6
};

enum WINDOWCOMPOSITIONATTRIB {
    WCA_UNDEFINED = 0,
    WCA_NCRENDERING_ENABLED = 1,
    WCA_NCRENDERING_POLICY = 2,
    WCA_TRANSITIONS_FORCEDISABLED = 3,
    WCA_ALLOW_NCPAINT = 4,
    WCA_CAPTION_BUTTON_BOUNDS = 5,
    WCA_NONCLIENT_RTL_LAYOUT = 6,
    WCA_FORCE_ICONIC_REPRESENTATION = 7,
    WCA_EXTENDED_FRAME_BOUNDS = 8,
    WCA_HAS_ICONIC_BITMAP = 9,
    WCA_THEME_ATTRIBUTES = 10,
    WCA_NCRENDERING_EXILED = 11,
    WCA_NCADORNMENTINFO = 12,
    WCA_EXCLUDED_FROM_LIVEPREVIEW = 13,
    WCA_VIDEO_OVERLAY_ACTIVE = 14,
    WCA_FORCE_ACTIVEWINDOW_APPEARANCE = 15,
    WCA_DISALLOW_PEEK = 16,
    WCA_CLOAK = 17,
    WCA_CLOAKED = 18,
    WCA_ACCENT_POLICY = 19,
    WCA_FREEZE_REPRESENTATION = 20,
    WCA_EVER_UNCLOAKED = 21,
    WCA_VISUAL_OWNER = 22,
    WCA_HOLOGRAPHIC = 23,
    WCA_EXCLUDED_FROM_DDA = 24,
    WCA_PASSIVEUPDATEMODE = 25,
    WCA_USEDARKMODECOLORS = 26,
    WCA_CORNER_STYLE = 27,
    WCA_PART_COLOR = 28,
    WCA_DISABLE_MOVESIZE_FEEDBACK = 29,
    WCA_SYSTEMBACKDROP_TYPE = 30,
    WCA_LAST = 31
};

enum DWM_SYSTEMBACKDROP_TYPE {
    DWMSBT_AUTO = 0,
    DWMSBT_NONE = 1,
    DWMSBT_MAINWINDOW = 2,      // Mica
    DWMSBT_TRANSIENTWINDOW = 3, // Acrylic  
    DWMSBT_TABBEDWINDOW = 4     // Tabbed Mica
};

struct ACCENT_POLICY {
    ACCENT_STATE AccentState;
    DWORD AccentFlags;
    DWORD GradientColor;
    DWORD AnimationId;
};

struct WINDOWCOMPOSITIONATTRIBDATA {
    WINDOWCOMPOSITIONATTRIB Attrib;
    PVOID pvData;
    SIZE_T cbData;
};

// Check if running Windows 11 (build 22000+)
bool IsWindows11OrLater() {
    HMODULE hNtdll = GetModuleHandleA("ntdll.dll");
    if (hNtdll) {
        typedef NTSTATUS(WINAPI *pRtlGetVersion)(OSVERSIONINFOEXW*);
        auto RtlGetVersionFunc = (pRtlGetVersion)GetProcAddress(hNtdll, "RtlGetVersion");
        
        if (RtlGetVersionFunc) {
            OSVERSIONINFOEXW versionInfo = { sizeof(OSVERSIONINFOEXW) };
            if (NT_SUCCESS(RtlGetVersionFunc(&versionInfo))) {
                return (versionInfo.dwMajorVersion > 10) || 
                       (versionInfo.dwMajorVersion == 10 && versionInfo.dwBuildNumber >= 22000);
            }
        }
    }
    return false;
}

// Enable DWM composition (removed deprecated function)
void EnableDWMComposition() {
    // DwmEnableComposition is deprecated and no longer needed on modern Windows
    // DWM composition is always enabled on Windows 8 and later
    // This function is kept for compatibility but does nothing
}

// Set window corners to rounded (helps with Mica)
void SetRoundedCorners(HWND hwnd) {
    DWORD preference = DWMWCP_ROUND;
    DwmSetWindowAttribute(hwnd, DWMWA_WINDOW_CORNER_PREFERENCE, &preference, sizeof(preference));
}

// Disable backdrop effect
void DisableBackdropEffect(HWND hwnd) {
    // First try modern API
    DWM_SYSTEMBACKDROP_TYPE noneType = DWMSBT_NONE;
    DwmSetWindowAttribute(hwnd, DWMWA_SYSTEMBACKDROP_TYPE, &noneType, sizeof(noneType));
    
    // Also disable via composition attribute
    HMODULE hUser = LoadLibraryA("user32.dll");
    if (hUser) {
        typedef BOOL(WINAPI *pSetWindowCompositionAttribute)(HWND, WINDOWCOMPOSITIONATTRIBDATA*);
        auto SetWindowCompositionAttributeFunc = (pSetWindowCompositionAttribute)GetProcAddress(hUser, "SetWindowCompositionAttribute");
        
        if (SetWindowCompositionAttributeFunc) {
            ACCENT_POLICY policy = { ACCENT_DISABLED, 0, 0, 0 };
            WINDOWCOMPOSITIONATTRIBDATA data = { WCA_ACCENT_POLICY, &policy, sizeof(policy) };
            SetWindowCompositionAttributeFunc(hwnd, &data);
        }
        FreeLibrary(hUser);
    }
}

// Apply blur effect (Windows 10 style)
void ApplyBlurEffect(HWND hwnd) {
    EnableDWMComposition();
    
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

// Apply Windows 11 Mica Effect
void ApplyMicaEffect(HWND hwnd) {
    if (!IsWindows11OrLater()) {
        // Fallback to blur on older systems
        ApplyBlurEffect(hwnd);
        return;
    }
    
    EnableDWMComposition();
    SetRoundedCorners(hwnd);
    
    // First disable any existing backdrop
    DisableBackdropEffect(hwnd);
    
    // Apply Mica using modern API
    DWM_SYSTEMBACKDROP_TYPE micaType = DWMSBT_MAINWINDOW;
    HRESULT hr = DwmSetWindowAttribute(hwnd, DWMWA_SYSTEMBACKDROP_TYPE, &micaType, sizeof(micaType));
    
    if (FAILED(hr)) {
        // Fallback to composition attribute method
        HMODULE hUser = LoadLibraryA("user32.dll");
        if (hUser) {
            typedef BOOL(WINAPI *pSetWindowCompositionAttribute)(HWND, WINDOWCOMPOSITIONATTRIBDATA*);
            auto SetWindowCompositionAttributeFunc = (pSetWindowCompositionAttribute)GetProcAddress(hUser, "SetWindowCompositionAttribute");
            
            if (SetWindowCompositionAttributeFunc) {
                ACCENT_POLICY policy = { ACCENT_ENABLE_HOSTBACKDROP, 0, 0, 0 };
                WINDOWCOMPOSITIONATTRIBDATA data = { WCA_ACCENT_POLICY, &policy, sizeof(policy) };
                SetWindowCompositionAttributeFunc(hwnd, &data);
            }
            FreeLibrary(hUser);
        }
    }
}

// Apply Windows 11 Acrylic Effect
void ApplyAcrylicEffect(HWND hwnd) {
    if (!IsWindows11OrLater()) {
        // Fallback: Use Windows 10 acrylic
        EnableDWMComposition();
        
        HMODULE hUser = LoadLibraryA("user32.dll");
        if (hUser) {
            typedef BOOL(WINAPI *pSetWindowCompositionAttribute)(HWND, WINDOWCOMPOSITIONATTRIBDATA*);
            auto SetWindowCompositionAttributeFunc = (pSetWindowCompositionAttribute)GetProcAddress(hUser, "SetWindowCompositionAttribute");
            
            if (SetWindowCompositionAttributeFunc) {
                ACCENT_POLICY policy = { ACCENT_ENABLE_ACRYLICBLURBEHIND, 0, 0x01000000, 0 }; // Semi-transparent
                WINDOWCOMPOSITIONATTRIBDATA data = { WCA_ACCENT_POLICY, &policy, sizeof(policy) };
                SetWindowCompositionAttributeFunc(hwnd, &data);
            }
            FreeLibrary(hUser);
        }
        return;
    }
    
    EnableDWMComposition();
    SetRoundedCorners(hwnd);
    
    // First disable any existing backdrop
    DisableBackdropEffect(hwnd);
    
    // Apply Acrylic using modern API
    DWM_SYSTEMBACKDROP_TYPE acrylicType = DWMSBT_TRANSIENTWINDOW;
    HRESULT hr = DwmSetWindowAttribute(hwnd, DWMWA_SYSTEMBACKDROP_TYPE, &acrylicType, sizeof(acrylicType));
    
    if (FAILED(hr)) {
        // Fallback to composition attribute method
        HMODULE hUser = LoadLibraryA("user32.dll");
        if (hUser) {
            typedef BOOL(WINAPI *pSetWindowCompositionAttribute)(HWND, WINDOWCOMPOSITIONATTRIBDATA*);
            auto SetWindowCompositionAttributeFunc = (pSetWindowCompositionAttribute)GetProcAddress(hUser, "SetWindowCompositionAttribute");
            
            if (SetWindowCompositionAttributeFunc) {
                ACCENT_POLICY policy = { ACCENT_ENABLE_ACRYLICBLURBEHIND, 0, 0x01000000, 0 };
                WINDOWCOMPOSITIONATTRIBDATA data = { WCA_ACCENT_POLICY, &policy, sizeof(policy) };
                SetWindowCompositionAttributeFunc(hwnd, &data);
            }
            FreeLibrary(hUser);
        }
    }
}

// Apply Tabbed Mica Effect
void ApplyTabbedMicaEffect(HWND hwnd) {
    if (!IsWindows11OrLater()) {
        ApplyBlurEffect(hwnd);
        return;
    }
    
    EnableDWMComposition();
    SetRoundedCorners(hwnd);
    DisableBackdropEffect(hwnd);
    
    DWM_SYSTEMBACKDROP_TYPE tabbedType = DWMSBT_TABBEDWINDOW;
    DwmSetWindowAttribute(hwnd, DWMWA_SYSTEMBACKDROP_TYPE, &tabbedType, sizeof(tabbedType));
}

//convert std::string to std::wstring
std::wstring StringToWString(const std::string& str) {
    if (str.empty()) return std::wstring();
    int size_needed = MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, NULL, 0);
    if (size_needed <= 0) return std::wstring();
    
    std::wstring wstr(size_needed, 0);
    MultiByteToWideChar(CP_UTF8, 0, str.c_str(), -1, &wstr[0], size_needed);
    return wstr;
}

bool GetFileIcon(const std::string& filePath, std::vector<uint8_t>& pngBytes) {
    if (filePath.empty()) return false;
    
    SHFILEINFO shFileInfo = {0};
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

    // Convert BGRA to RGBA
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

void initMethodChannel(flutter::FlutterEngine* flutter_instance) {
    const static std::string channel_name("file_icon_channel");

    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            flutter_instance->messenger(), channel_name,
            &flutter::StandardMethodCodec::GetInstance());

    channel->SetMethodCallHandler(
        [flutter_instance](const flutter::MethodCall<flutter::EncodableValue>& call, 
           std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {

            HWND hwnd = GetActiveWindow();
            if (!hwnd) {
                result->Error("HWND_NOT_FOUND", "Could not retrieve window handle.");
                return;
            }

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
            } 
            else if (call.method_name().compare("applyBlur") == 0) {
                ApplyBlurEffect(hwnd);
                result->Success();
            }
            else if (call.method_name().compare("applyMica") == 0) {
                ApplyMicaEffect(hwnd);
                result->Success();
            }
            else if (call.method_name().compare("applyAcrylic") == 0) {
                ApplyAcrylicEffect(hwnd);
                result->Success();
            }
            else if (call.method_name().compare("applyTabbedMica") == 0) {
                ApplyTabbedMicaEffect(hwnd);
                result->Success();
            }
            else if (call.method_name().compare("disableBackdrop") == 0) {
                DisableBackdropEffect(hwnd);
                result->Success();
            }
            else {
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