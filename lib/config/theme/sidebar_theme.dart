import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/extensions/theme_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';

Color themeDecider(int selectedTheme) {
  if (selectedTheme == 0) {
    return GColors.mainThemeColor.adjustBrightness(0.8);
  }
  if (selectedTheme == 1) {
    return GColors.darkThemeColor.adjustBrightness(0.2);
  } else {
    return WindowUtils.getSystemAccentColor().adjustBrightness(0.7);
  }
}

ThemeData sidebarTheme({
  required Color mainColor,
  required double opacity,
  required bool hasBorder,
}) {
  //todo clean up a lil bit
  return ThemeData(
    fontFamily: 'Nova',
    scaffoldBackgroundColor: mainColor.withValues(alpha: opacity),
    brightness: Brightness.dark,
    iconTheme: IconThemeData(color: mainColor.shade100),
    tooltipTheme: TooltipThemeData(
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
    ),
    extensions: [
      BorderExtension(
        globalBorderWidth: 1,
        color: hasBorder ? mainColor : mainColor.withValues(alpha: 0),
      ),
    ],
    textTheme: TextTheme(
      labelLarge: TextStyle(
        color: mainColor.shade100,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
      labelMedium: TextStyle(
        color: mainColor.shade100,
        fontWeight: FontWeight.w600,
        overflow: TextOverflow.ellipsis,
      ),
      labelSmall: TextStyle(
        color: mainColor.shade100,
        overflow: TextOverflow.ellipsis,
      ),
      //on top of folder icon
      bodySmall: TextStyle(
        color: mainColor.shade600,
        overflow: TextOverflow.ellipsis,
        fontSize: 12,
      ),
    ),
    sliderTheme: SliderThemeData(
      thumbColor: mainColor.shade100,
      inactiveTrackColor: mainColor.shade300,
      activeTrackColor: mainColor.shade100,
    ),
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStatePropertyAll(mainColor.shade600),
      fillColor:
          WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return mainColor.shade100;
        }
        return mainColor.withValues(alpha: 0);
      }),
      side: BorderSide(
        color: mainColor.shade100,
        width: 2,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStatePropertyAll(mainColor.shade100),
    ),
    primaryColor: mainColor,
    secondaryHeaderColor: mainColor.shade600,
    dividerTheme: DividerThemeData(
      color: mainColor.shade100,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(mainColor.shade600),
        elevation: WidgetStatePropertyAll(1),
        shadowColor: WidgetStatePropertyAll(mainColor.shade800),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kOuterRadius),
          ),
        ),
        iconColor: WidgetStatePropertyAll(mainColor.shade100),
      ),
    ),
  );
}
