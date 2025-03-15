import 'package:flutter/material.dart';

RadioThemeData sidebarRadioTheme(Color mainColor) {
  return RadioThemeData(
    splashRadius: 9,
    fillColor: WidgetStatePropertyAll(mainColor),
  );
}
