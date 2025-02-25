import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:win32/win32.dart';
import 'package:window_manager/window_manager.dart';

class WindowsUtils {
  static late final Offset windowsPosition;
  final AnimationController controller;
  Offset _originalPosition = Offset.zero;

  WindowsUtils({required this.controller});

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

  Future<void> getInitialPosition() async {
    final position = await windowManager.getPosition();
    _originalPosition = Offset(position.dx.toDouble(), position.dy.toDouble());
  }

  Future<void> animateTo(Offset targetOffset) async {
    final currentPosition = await windowManager.getPosition();
    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut, // Apply your desired curve here
    );

    // Declare the animation variable first
    late Animation<Offset> animation;

    animation = Tween<Offset>(
      begin:
          Offset(currentPosition.dx.toDouble(), currentPosition.dy.toDouble()),
      end: targetOffset,
    ).animate(curvedAnimation)
      ..addListener(() async {
        await windowManager.setPosition(animation.value);
      });

    controller.forward(from: 0);
  }

  Offset get originalPosition => _originalPosition;

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
