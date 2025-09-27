import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:injectable/injectable.dart';
import 'package:system_theme/system_theme.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/core/error/warnings.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/utils/native_plugins/window_aero_blur.dart';

@lazySingleton
class WindowsUtils with LogLayerMixin {
  Future<void> init() async {
    logInfo(init);
    try {
      await Window.initialize();
      await windowManager.ensureInitialized();
      await loadSystemAccentColor();
      await windowManager.waitUntilReadyToShow(
        const WindowOptions(
          alwaysOnTop: true,
          size: Size(800, 500),
          center: true,
          title: 'SpotBar',
          titleBarStyle: TitleBarStyle.normal,
          skipTaskbar: true,
        ),
        () async {
          await windowManager.setResizable(true);
          // await windowManager.setAsFrameless();
        },
      );
    } on SystemAccentColorWarning catch (_) {
      //windows default accent used
    } catch (e) {
      throw WindowsInitFailure(e);
    } finally {
      logSuccess('Window initialized successfully');
    }
  }

  //---system accent color---
  Future<void> loadSystemAccentColor() async {
    try {
      await SystemTheme.accentColor.load();
    } catch (e) {
      throw SystemAccentColorWarning(e);
    }
  }

  //---window effects----
  Future<void> transparent() async {
    try {
      await Window.setEffect(effect: WindowEffect.transparent);
    } catch (e) {
      throw BackgroundEffectWarning(e);
    }
  }

  Future<void> blur() async {
    try {
      await Window.setEffect(effect: WindowEffect.transparent);
      await WindowAeroBlur.applyAeroBlur();
    } catch (e) {
      throw BackgroundEffectWarning(e);
    }
  }

  Future<void> mica({bool dark = false}) async {
    try {
      await Window.setEffect(effect: WindowEffect.mica, dark: dark);
    } catch (e) {
      throw BackgroundEffectWarning(e);
    }
  }

  Future<void> acrylic({bool dark = false}) async {
    try {
      await Window.setEffect(effect: WindowEffect.acrylic, dark: dark);
    } catch (e) {
      throw BackgroundEffectWarning(e);
    }
  }
}

/*

  static Future<int> getAppWindowHandle() async {
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
 */
