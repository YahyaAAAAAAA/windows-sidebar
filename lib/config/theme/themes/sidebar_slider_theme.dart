import 'package:flutter/material.dart';

SliderThemeData sidebarSliderTheme(Color mainColor) {
  return SliderThemeData(
    thumbColor: mainColor,
    inactiveTrackColor: mainColor.withValues(alpha: 0.7),
    activeTrackColor: mainColor,
    valueIndicatorColor: mainColor,
    valueIndicatorTextStyle: TextStyle(
      color: mainColor,
    ),
  );
}
