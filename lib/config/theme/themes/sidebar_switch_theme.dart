import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';

SwitchThemeData sidebarSwitchTheme(
    Color mainColor, Color textColor, double opacity) {
  return SwitchThemeData(
    trackOutlineColor: WidgetStatePropertyAll(mainColor.shade400),
    trackOutlineWidth: WidgetStatePropertyAll(1),
    thumbColor: WidgetStatePropertyAll(textColor),
    trackColor:
        WidgetStatePropertyAll(mainColor.shade600.withValues(alpha: opacity)),
  );
}
