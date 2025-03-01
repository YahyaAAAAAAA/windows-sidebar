import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';

class GColors {
  static Color windowColor = WindowUtils.getSystemAccentColor();

  static Color transparent = Colors.transparent;

  //todo incase of errors getting windows color
  static Color windowColorFallback = Colors.black;
}
