import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

class WindowUtils {
  static Offset originalPosition = Offset.zero;

  static Future<void> setUp() async {
    await windowManager.setResizable(false);
    await windowManager.setAsFrameless();
  }

  static Future<void> alignRight() async {
    await windowManager.setAlignment(Alignment.centerRight);

    var screenSize = await screenRetriever.getPrimaryDisplay();
    var windowSize = await windowManager.getSize();
    var currentPosition = await windowManager.getPosition();

    int screenHeight = screenSize.size.height.toInt();
    int windowHeight = windowSize.height.toInt();
    double newY = (screenHeight - windowHeight) / 2;

    int windowWidth = windowSize.width.toInt();
    double newX = currentPosition.dx + windowWidth - 1;

    await windowManager.setPosition(Offset(newX, newY));
  }

  static Future<void> centerOnY() async {
    var screenSize = await screenRetriever.getPrimaryDisplay();
    var windowSize = await windowManager.getSize();
    var currentPosition = await windowManager.getPosition();

    int screenHeight = screenSize.size.height.toInt();
    int windowHeight = windowSize.height.toInt();
    double newY = (screenHeight - windowHeight) / 2;

    await windowManager.setPosition(Offset(currentPosition.dx, newY));
  }

  //reads windows system accent color from the registry
  static Color getSystemAccentColor() {
    //memory allocation
    final hKey = calloc<HANDLE>();
    final result = RegOpenKeyEx(
        HKEY_CURRENT_USER,
        r'SOFTWARE\Microsoft\Windows\DWM'.toNativeUtf16(),
        0,
        REG_SAM_FLAGS.KEY_READ,
        hKey);

    if (result != WIN32_ERROR.ERROR_SUCCESS) {
      calloc.free(hKey);
      //default fallback color
      return GColors.windowColorFallback;
    }

    final data = calloc<DWORD>();
    final dataSize = calloc<DWORD>()..value = sizeOf<DWORD>();

    RegQueryValueEx(hKey.value, 'AccentColor'.toNativeUtf16(), nullptr, nullptr,
        data.cast<BYTE>(), dataSize);

    int colorValue = data.value;
    calloc.free(hKey);
    calloc.free(data);
    calloc.free(dataSize);

    //extract ARGB color
    return Color.fromARGB(
      //alpha
      (colorValue >> 24) & 0xFF,
      //blue → red
      (colorValue >> 0) & 0xFF,
      //green
      (colorValue >> 8) & 0xFF,
      //red → blue
      (colorValue >> 16) & 0xFF,
    );
  }

  //todo might not use

  /// Watches for system accent color changes in a separate isolate
  static Stream<Color> watchAccentColor() async* {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(watchColorIsolate, receivePort.sendPort);

    await for (final color in receivePort) {
      yield color as Color;
    }
  }

  /// Runs the registry watcher in a separate isolate
  static void watchColorIsolate(SendPort sendPort) {
    final hKey = calloc<HANDLE>();
    if (RegOpenKeyEx(
            HKEY_CURRENT_USER,
            r'SOFTWARE\Microsoft\Windows\DWM'.toNativeUtf16(),
            0,
            REG_SAM_FLAGS.KEY_NOTIFY,
            hKey) !=
        WIN32_ERROR.ERROR_SUCCESS) {
      calloc.free(hKey);
      sendPort.send(GColors.windowColorFallback);
      return;
    }

    final event = CreateEvent(nullptr, FALSE, FALSE, nullptr);

    while (true) {
      RegNotifyChangeKeyValue(hKey.value, FALSE,
          REG_NOTIFY_FILTER.REG_NOTIFY_CHANGE_LAST_SET, event, TRUE);
      WaitForSingleObject(event, INFINITE); // Wait for a change

      sendPort.send(getSystemAccentColor()); // Send updated color
    }
  }

  static Future<int> getCurrentWindowHandle() async {
    bool hasFocus = await windowManager.isFocused();
    if (!hasFocus) {
      //save current window handle
      return GetForegroundWindow();
    }
    return 0;
  }

  static void focusPreviousWindow(int hwnd) {
    //do nothing
    if (hwnd == 0) {
      return;
    }

    //give focus
    SetForegroundWindow(hwnd);
  }

  //window effect
  static Future<void> transparent() async {
    await Window.setEffect(effect: WindowEffect.transparent);
  }

  static Future<void> blur() async {
    await Window.setEffect(effect: WindowEffect.aero);
  }

  static Future<void> solid() async {
    await Window.setEffect(effect: WindowEffect.solid);
  }
}
