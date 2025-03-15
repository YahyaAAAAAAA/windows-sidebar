import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';

CheckboxThemeData sidebarCheckboxTheme(
    Color mainColor, Color iconColor, double opacity) {
  return CheckboxThemeData(
    checkColor: WidgetStatePropertyAll(iconColor),
    fillColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return mainColor.shade600
              .withValues(alpha: opacity == 0 ? 0.1 : opacity);
        }
        return mainColor.withValues(alpha: 0);
      },
    ),
    splashRadius: 9,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    side: BorderSide(
      color: opacity <= 0.5 ? mainColor.shade400 : mainColor.shade100,
      width: 1,
    ),
  );
}
