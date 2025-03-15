import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';

InputDecorationTheme sidebarInputDecorationTheme(Color mainColor) {
  return InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: mainColor.shade600,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: mainColor.shade100,
        width: 1,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: mainColor.shade100,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: mainColor.shade100,
        width: 1,
      ),
    ),
    filled: true,
    fillColor: mainColor.shade700,
    labelStyle: TextStyle(
      color: mainColor.shade100,
      fontSize: 12,
    ),
    hintStyle: TextStyle(
      color: mainColor.shade200,
      fontSize: 12,
    ),
    errorStyle: TextStyle(
      color: mainColor.shade100,
      fontSize: 12,
    ),
  );
}
