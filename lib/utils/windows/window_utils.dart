import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:win32/win32.dart';
import 'package:window_manager/window_manager.dart';

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

    //move window to new position
    await windowManager
        .setPosition(Offset(newX.toDouble() + 192, newY.toDouble()));

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

  //! ---------------------------------------------------------------------

  static int getFlutterWindowHandle(String title) {
    return FindWindow(nullptr, title.toNativeUtf16());
  }

  //makes the window click-through
  static void setWindowClickThrough(int hwnd) {
    final int currentStyle =
        GetWindowLongPtr(hwnd, WINDOW_LONG_PTR_INDEX.GWL_EXSTYLE);

    //add WS_EX_LAYERED and WS_EX_TRANSPARENT flags
    SetWindowLongPtr(
        hwnd,
        WINDOW_LONG_PTR_INDEX.GWL_EXSTYLE,
        currentStyle |
            WINDOW_EX_STYLE.WS_EX_LAYERED |
            WINDOW_EX_STYLE.WS_EX_TRANSPARENT);
  }

  static void setWindowClickable(int hwnd) {
    final int currentStyle =
        GetWindowLongPtr(hwnd, WINDOW_LONG_PTR_INDEX.GWL_EXSTYLE);

    // Remove WS_EX_TRANSPARENT flag (keep WS_EX_LAYERED)
    SetWindowLongPtr(hwnd, WINDOW_LONG_PTR_INDEX.GWL_EXSTYLE,
        currentStyle & ~WINDOW_EX_STYLE.WS_EX_TRANSPARENT);
  }
}
