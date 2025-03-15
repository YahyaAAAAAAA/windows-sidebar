import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';

PopupMenuThemeData sidebarPopupMenuTheme(Color mainColor, Color textColor) {
  return PopupMenuThemeData(
    color: mainColor.shade600,
    textStyle: TextStyle(
      color: textColor,
      overflow: TextOverflow.ellipsis,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    position: PopupMenuPosition.under,
    elevation: 1,
  );
}
