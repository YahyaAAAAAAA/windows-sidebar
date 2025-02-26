import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:windows_widgets/utils/global_colors.dart';

class WindowUtils {
  static late final Offset windowsPosition;

  static Future<void> moveWindowToRightEdge() async {
    //get screen size
    var screenSize = await screenRetriever.getPrimaryDisplay();

    //get window size
    var windowSize = await windowManager.getSize();

    //calculate new position
    int screenWidth = screenSize.size.width.toInt();
    int screenHeight = screenSize.size.height.toInt();
    int windowWidth = windowSize.width.toInt();
    int windowHeight = windowSize.height.toInt();

    int newX = screenWidth - windowWidth;
    int newY = (screenHeight - windowHeight) ~/ 2;

    int marginFactor = windowWidth - 8;

    //move window to new position
    await windowManager
        .setPosition(Offset(newX.toDouble() + marginFactor, newY.toDouble()));

    windowsPosition = await windowManager.getPosition();
  }

  static Future<void> centerWindowOnY() async {
    var screenSize = await screenRetriever.getPrimaryDisplay();
    var windowSize = await windowManager.getSize();
    var currentPosition = await windowManager.getPosition();

    int screenHeight = screenSize.size.height.toInt();
    int windowHeight = windowSize.height.toInt();
    int newY = (screenHeight - windowHeight) ~/ 2;

    await windowManager
        .setPosition(Offset(currentPosition.dx, newY.toDouble()));
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
}
