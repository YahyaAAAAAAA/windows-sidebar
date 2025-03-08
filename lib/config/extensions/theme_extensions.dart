import 'dart:ui';

import 'package:flutter/material.dart';

class BorderExtension extends ThemeExtension<BorderExtension> {
  final double globalBorderWidth;
  final Color color;

  BorderExtension({
    required this.globalBorderWidth,
    required this.color,
  });

  @override
  ThemeExtension<BorderExtension> copyWith({
    double? globalBorderWidth,
    Color? color,
  }) {
    return BorderExtension(
      globalBorderWidth: globalBorderWidth ?? this.globalBorderWidth,
      color: color ?? this.color,
    );
  }

  @override
  ThemeExtension<BorderExtension> lerp(
      ThemeExtension<BorderExtension>? other, double t) {
    if (other is! BorderExtension) {
      return this;
    }
    return BorderExtension(
      globalBorderWidth:
          lerpDouble(globalBorderWidth, other.globalBorderWidth, t)!,
      color: color,
    );
  }
}
