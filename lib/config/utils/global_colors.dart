import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';

class GColors {
  static Color windowColor = WindowUtils.getSystemAccentColor();

  //todo incase of errors getting windows color
  static Color windowColorFallback = Colors.black;
}
