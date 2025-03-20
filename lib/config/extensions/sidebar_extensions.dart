import 'dart:ui';

import 'package:flutter/material.dart';

class SidebarExtensions extends ThemeExtension<SidebarExtensions> {
  final double globalBorderWidth;
  final Color color;

  SidebarExtensions({
    required this.globalBorderWidth,
    required this.color,
  });

  @override
  ThemeExtension<SidebarExtensions> copyWith({
    double? globalBorderWidth,
    double? scaffoldPadding,
    Color? color,
  }) {
    return SidebarExtensions(
      globalBorderWidth: globalBorderWidth ?? this.globalBorderWidth,
      color: color ?? this.color,
    );
  }

  @override
  ThemeExtension<SidebarExtensions> lerp(
      ThemeExtension<SidebarExtensions>? other, double t) {
    if (other is! SidebarExtensions) {
      return this;
    }
    return SidebarExtensions(
      globalBorderWidth:
          lerpDouble(globalBorderWidth, other.globalBorderWidth, t)!,
      color: color,
    );
  }
}
