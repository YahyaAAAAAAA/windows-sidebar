import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/sidebar_extensions.dart';

List<ThemeExtension<dynamic>> sidebarExtensionsTheme(
    bool hasBorder, Color mainColor, double scaffoldPadding) {
  return [
    SidebarExtensions(
      globalBorderWidth: 1,
      color: hasBorder ? mainColor : mainColor.withValues(alpha: 0),
      scaffoldPadding: scaffoldPadding,
    ),
  ];
}
