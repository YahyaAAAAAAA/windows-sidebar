import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';

TextTheme sidebarTextTheme(
  Color mainColor,
  Color textColor,
) {
  return TextTheme(
    labelLarge: TextStyle(
      color: textColor,
      fontWeight: FontWeight.bold,
      overflow: TextOverflow.ellipsis,
    ),
    labelMedium: TextStyle(
      color: textColor,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    labelSmall: TextStyle(
      color: textColor,
      overflow: TextOverflow.ellipsis,
      fontSize: 12,
    ),
    //on top of folder icon
    bodySmall: TextStyle(
      color: mainColor.shade600,
      overflow: TextOverflow.ellipsis,
      fontSize: 12,
    ),
  );
}
