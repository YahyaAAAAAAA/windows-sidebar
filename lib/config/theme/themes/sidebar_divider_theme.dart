import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';

DividerThemeData sidebarDividerTheme(Color mainColor) {
  return DividerThemeData(
    color: mainColor.shade400,
  );
}
