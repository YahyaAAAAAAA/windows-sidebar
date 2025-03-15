import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';

TooltipThemeData sidebarTooltipTheme(Color mainColor) {
  return TooltipThemeData(
    exitDuration: Duration.zero,
    decoration: BoxDecoration(
      color: mainColor.shade600,
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    textStyle: TextStyle(
      color: mainColor.shade100,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
  );
}
