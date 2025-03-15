import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';

IconButtonThemeData sidebarIconButtonTheme(Color mainColor, Color textColor) {
  return IconButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(mainColor.withValues(alpha: 0)),
      elevation: WidgetStatePropertyAll(0),
      shadowColor: WidgetStatePropertyAll(mainColor.withValues(alpha: 0)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kOuterRadius),
        ),
      ),
      iconColor: WidgetStatePropertyAll(textColor),
    ),
  );
}
