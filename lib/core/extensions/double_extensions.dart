import 'package:flutter/material.dart';

extension DoubleExtensions on double {
  bool toBool() {
    if (this >= 1) {
      return true;
    } else {
      return false;
    }
  }

  Widget get height => SizedBox(height: this);

  Widget get width => SizedBox(width: this);
}
