// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color get shade50 => lighten(0.4);
  Color get shade100 => lighten(0.3);
  Color get shade200 => lighten(0.2);
  Color get shade300 => lighten(0.1);
  Color get shade400 => lighten(0.05);
  //original color
  Color get shade500 => this;
  Color get shade600 => darken(0.05);
  Color get shade700 => darken(0.1);
  Color get shade800 => darken(0.2);
  Color get shade900 => darken(0.3);

  //lightens the color by increasing brightness
  Color lighten(double amount) {
    final hsl = HSLColor.fromColor(this);
    final lightened = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return lightened.toColor();
  }

  //darkens the color by decreasing brightness
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    final darkened = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0),
    );
    return darkened.toColor();
  }

  bool isDark() {
    final double luminance = computeLuminance();

    //return true if the color is dark (luminance < 0.5)
    return luminance < 0.5;
  }

  Color adjustBrightness(double targetBrightness) {
    final hsvColor = HSVColor.fromColor(this);

    //adjust the brightness
    final adjustedColor = hsvColor.withValue(targetBrightness);

    return adjustedColor.toColor();
  }

  /// Mixes this color with another color.
  ///
  /// [other] - The color to mix with
  /// [ratio] - The mixing ratio (0.0 to 1.0)
  ///   - 0.0 returns this color completely
  ///   - 0.5 returns an equal mix of both colors
  ///   - 1.0 returns the other color completely
  ///
  /// Example:
  /// ```dart
  /// final redColor = Colors.red;
  /// final blueColor = Colors.blue;
  /// final purpleColor = redColor.mix(blueColor, 0.5); // Equal mix
  /// final mostlyRed = redColor.mix(blueColor, 0.2);   // 80% red, 20% blue
  /// ```
  Color mix(Color other, double ratio, {bool preserveAlpha = true}) {
    // Clamp ratio to ensure it's between 0.0 and 1.0
    ratio = ratio.clamp(0.0, 1.0);

    // Linear interpolation for each color component
    final int newRed = (red + (other.red - red) * ratio).round();
    final int newGreen = (green + (other.green - green) * ratio).round();
    final int newBlue = (blue + (other.blue - blue) * ratio).round();

    // Handle alpha channel based on preserveAlpha flag
    final int newAlpha =
        preserveAlpha ? 255 : (alpha + (other.alpha - alpha) * ratio).round();

    return Color.fromARGB(
      newAlpha,
      newRed,
      newGreen,
      newBlue,
    ).withValues(alpha: a);
  }

  /// Mixes this color with another color using alpha blending.
  /// This simulates how colors would naturally blend when one is transparent.
  ///
  /// [other] - The color to blend with (background color)
  /// [alpha] - The alpha/opacity of this color (0.0 to 1.0)
  ///
  /// Example:
  /// ```dart
  /// final redColor = Colors.red;
  /// final whiteBackground = Colors.white;
  /// final blendedColor = redColor.alphaBlend(whiteBackground, 0.7);
  /// ```
  Color alphaBlend(Color background, double alpha) {
    alpha = alpha.clamp(0.0, 1.0);

    final double inverseAlpha = 1.0 - alpha;

    final int newRed = (r * alpha + background.r * inverseAlpha).round();
    final int newGreen = (g * alpha + background.g * inverseAlpha).round();
    final int newBlue = (b * alpha + background.b * inverseAlpha).round();

    return Color.fromARGB(255, newRed, newGreen, newBlue);
  }

  /// Mixes multiple colors with specified weights.
  ///
  /// [colors] - List of colors to mix
  /// [weights] - List of weights for each color (should sum to 1.0)
  ///
  /// Example:
  /// ```dart
  /// final mixedColor = Colors.red.mixMultiple(
  ///   [Colors.green, Colors.blue],
  ///   [0.3, 0.2], // This color (red) gets remaining weight (0.5)
  /// );
  /// ```
  Color mixMultiple(List<Color> colors, List<double> weights) {
    assert(
      colors.length == weights.length,
      'Colors and weights lists must have the same length',
    );

    // Calculate the weight for this color
    final double thisWeight = math.max(
      0.0,
      1.0 - weights.fold(0.0, (sum, weight) => sum + weight),
    );

    double totalRed = r * thisWeight;
    double totalGreen = g * thisWeight;
    double totalBlue = b * thisWeight;
    double totalAlpha = a * thisWeight;

    for (int i = 0; i < colors.length; i++) {
      final weight = weights[i].clamp(0.0, 1.0);
      totalRed += colors[i].r * weight;
      totalGreen += colors[i].g * weight;
      totalBlue += colors[i].b * weight;
      totalAlpha += colors[i].a * weight;
    }

    return Color.fromARGB(
      totalAlpha.round().clamp(0, 255),
      totalRed.round().clamp(0, 255),
      totalGreen.round().clamp(0, 255),
      totalBlue.round().clamp(0, 255),
    );
  }

  /// Creates a gradient-like mix between this color and another color.
  /// Returns a list of colors representing the gradient steps.
  ///
  /// [other] - The target color
  /// [steps] - Number of gradient steps (minimum 2)
  ///
  /// Example:
  /// ```dart
  /// final gradient = Colors.red.gradientTo(Colors.blue, 5);
  /// // Returns [red, red-purple, purple, blue-purple, blue]
  /// ```
  List<Color> gradientTo(Color other, int steps) {
    assert(steps >= 2, 'Steps must be at least 2');

    final List<Color> gradient = [];

    for (int i = 0; i < steps; i++) {
      final double ratio = i / (steps - 1);
      gradient.add(mix(other, ratio));
    }

    return gradient;
  }

  /// Mixes this color with white to create a tint.
  ///
  /// [amount] - Amount of white to mix (0.0 to 1.0)
  ///
  /// Example:
  /// ```dart
  /// final lightRed = Colors.red.tint(0.3); // 70% red, 30% white
  /// ```
  Color tint(double amount) {
    return mix(Colors.white, amount);
  }

  /// Mixes this color with black to create a shade.
  ///
  /// [amount] - Amount of black to mix (0.0 to 1.0)
  ///
  /// Example:
  /// ```dart
  /// final darkRed = Colors.red.shade(0.3); // 70% red, 30% black
  /// ```
  Color shade(double amount) {
    return mix(Colors.black, amount);
  }

  /// Mixes this color with grey to create a tone.
  ///
  /// [amount] - Amount of grey to mix (0.0 to 1.0)
  /// [grey] - The grey color to use (defaults to 50% grey)
  ///
  /// Example:
  /// ```dart
  /// final mutedRed = Colors.red.tone(0.4); // 60% red, 40% grey
  /// ```
  Color tone(double amount, [Color grey = const Color(0xFF808080)]) {
    return mix(grey, amount);
  }

  /// Returns the inverted color by subtracting each RGB component from 255
  /// The alpha channel remains unchanged
  Color get inverted {
    return Color.fromARGB(
      alpha, // Keep original alpha
      255 - red, // Invert red component
      255 - green, // Invert green component
      255 - blue, // Invert blue component
    );
  }

  /// Returns the inverted color with optional alpha override
  /// If [newAlpha] is provided, it replaces the original alpha value
  Color invertedWithAlpha([int? newAlpha]) {
    return Color.fromARGB(
      newAlpha ?? alpha, // Use new alpha if provided, otherwise keep original
      255 - red,
      255 - green,
      255 - blue,
    );
  }

  /// Returns a black or white color based on the luminance of this color
  /// Useful for determining readable text color on colored backgrounds
  Color get contrastColor {
    // Calculate luminance using standard formula
    final luminance = (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
