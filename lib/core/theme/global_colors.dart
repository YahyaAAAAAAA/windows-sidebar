import 'package:flutter/material.dart';
import 'package:system_theme/system_theme.dart';
import 'package:windows_widgets/core/extensions/color_extensions.dart';
import 'package:windows_widgets/core/utils/accent_colors.dart';

//1- define normal color as a static members (red, yellow, ...)
//2- inside getColors the 'normal colors' are used directly as appropriate to the opposite parameter in GlobalColorsManager

class GColors {
  // Light theme colors
  static const Color gray = Color(0xFF878787); //disabled
  static const Color lightGray = Color(0xFFf3f3f3); //background
  static const Color frenchGray = Color(0xFFe5e5e5); //divider/borders
  static const Color white = Color(0xFFfbfbfb); //container
  static const Color sugar = Color(0xFFfefefe); //surface buttons
  static const Color black = Color(0xFF000000); //font
  static const Color red = Color(0xFFd13438); //error
  static const Color brown = Color(0xFF9d5d00); //warning
  static const Color green = Color(0xFF0f7b0f); //success
  static const Color craterBrown = Color(0xFF442726); //toast error background
  static const Color lightYellow = Color(0xFFfff4ce); //toast warning background
  static const Color lightGreen = Color(0xFFdff6dd); //toast success background

  // Windows 11 Dark theme colors
  static const Color darkBackground = Color(0xFF202020); // Dark background
  static const Color darkSurface = Color(0xFF2c2c2c); // Dark surface/container
  static const Color darkAppbar = Color(0xFF1c1c1c); // Darker appbar
  static const Color darkBorder = Color(0xFF3c3c3c); // Dark border
  static const Color darkDivider = Color(0xFF404040); // Dark divider
  static const Color darkText = Color(0xFFffffff); // White text
  static const Color darkIcon = Color(0xFFffffff); // White icons
  static const Color darkDisabled = Color(0xFF6d6d6d); // Dark disabled
  static const Color darkBlue = Color(0xFF60cdff); // Windows 11 accent blue
  static const Color darkRed = Color(0xFFff9999); // error
  static const Color yellow = Color(0xFFfce100); //warning
  static const Color mantis = Color(0xFF6ccb5f); //success
  static const Color darkHover = Color(0xFF404040); // Dark hover state
  static const Color cinderella = Color(0xFFfde7e9); //toast error background
  static const Color darkYellow = Color(0xFF433519); //toast warning background
  static const Color darkGreen = Color(0xFF393d1b); //toast success background

  static GlobalColorsManager getColors({
    required int themeIndex,
    required int accentColorIndex,
    required bool useSystemAccentColor,
  }) {
    final Color accent;
    if (useSystemAccentColor) {
      accent = themeIndex == 1 ? SystemTheme.accentColor.lighter : SystemTheme.accentColor.dark;
    } else {
      accent = themeIndex == 1
          ? AccentColorsManager.windows11AccentColors[accentColorIndex].dark
          : AccentColorsManager.windows11AccentColors[accentColorIndex].light;
    }

    switch (themeIndex) {
      case 1:
        return GlobalColorsManager(
          background: darkBackground,
          appbar: darkAppbar,
          dialog: darkSurface,
          container: darkSurface,
          iconButton: darkSurface,
          textField: darkSurface,
          indicator: darkSurface.darken(0.02),
          textButton: Colors.transparent,
          border: darkBorder,
          divider: darkDivider,
          disabled: darkDisabled,
          shadow: black,
          icon: darkIcon,
          text: darkText,
          error: darkRed,
          warning: yellow,
          success: mantis,
          primary: accent,
          secondary: accent.withValues(alpha: 0.3),
          hover: darkText.withValues(alpha: 0.03),
          focus: darkText.withValues(alpha: 0.03),
          splash: darkText.withValues(alpha: 0.05),
          highlight: darkText.withValues(alpha: 0.04),
          toastError: craterBrown,
          toastWarning: darkYellow,
          toastSuccess: darkGreen,
        );
      default:
        return GlobalColorsManager(
          background: lightGray,
          appbar: lightGray,
          dialog: lightGray,
          container: white,
          iconButton: sugar,
          textField: white,
          textButton: white,
          indicator: white.darken(0.02),
          border: frenchGray,
          divider: frenchGray,
          disabled: gray,
          icon: black,
          text: black,
          shadow: black,
          error: red,
          warning: brown,
          success: green,
          primary: accent,
          secondary: accent.withValues(alpha: 0.3),
          hover: black.withValues(alpha: 0.03),
          focus: black.withValues(alpha: 0.03),
          splash: black.withValues(alpha: 0.05),
          highlight: black.withValues(alpha: 0.04),
          toastError: cinderella,
          toastWarning: lightYellow,
          toastSuccess: lightGreen,
        );
    }
  }
}

class GlobalColorsManager {
  final Color background;
  final Color appbar;
  final Color container;
  final Color divider;
  final Color border;
  final Color text;
  final Color icon;
  final Color dialog;
  final Color disabled;
  final Color primary;
  final Color indicator;
  final Color secondary;
  final Color textButton;
  final Color iconButton;
  final Color textField;
  final Color error;
  final Color warning;
  final Color success;
  final Color hover;
  final Color focus;
  final Color shadow;
  final Color splash;
  final Color highlight;
  final Color toastSuccess;
  final Color toastWarning;
  final Color toastError;

  const GlobalColorsManager({
    required this.background,
    required this.appbar,
    required this.container,
    required this.divider,
    required this.border,
    required this.text,
    required this.indicator,
    required this.icon,
    required this.dialog,
    required this.disabled,
    required this.primary,
    required this.secondary,
    required this.textButton,
    required this.iconButton,
    required this.textField,
    required this.error,
    required this.warning,
    required this.success,
    required this.hover,
    required this.focus,
    required this.shadow,
    required this.splash,
    required this.highlight,
    required this.toastSuccess,
    required this.toastWarning,
    required this.toastError,
  });
}
