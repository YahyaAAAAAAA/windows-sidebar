import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_checkbox_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_dialog_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_divider_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_extensions_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_icon_button_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_icon_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_input_decoration_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_popup_menu_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_radio_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_slider_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_switch_theme.dart';
import 'package:windows_widgets/config/theme/themes/sidebar_text_theme.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';

Color themeDecider(int selectedTheme) {
  //default
  if (selectedTheme == 0) {
    return GColors.mainThemeColor.adjustBrightness(0.8);
  }
  //device
  else if (selectedTheme == 1) {
    return WindowUtils.getSystemAccentColor().adjustBrightness(0.7);
  }
  //light
  else if (selectedTheme == 2) {
    return Color(0xFFf3f3f3).adjustBrightness(0.9);
  }
  //dark
  else {
    return Color(0xFF282828);
  }
}

ThemeData sidebarTheme({
  required Color mainColor,
  required double opacity,
  required bool hasBorder,
}) {
  Color textColor =
      mainColor.isDark() ? mainColor.lighten(1) : mainColor.darken(1);

  Color dialogColor =
      mainColor.isDark() ? mainColor.lighten(1) : mainColor.darken(1);

  if (!mainColor.isDark() && opacity <= 0.5) {
    textColor = mainColor.lighten(1);
  }

  return ThemeData(
    fontFamily: 'Nova',
    scaffoldBackgroundColor: mainColor.withValues(alpha: opacity),
    canvasColor: mainColor.shade600,
    hoverColor: textColor.withValues(alpha: 0.1),
    iconTheme: sidebarIconTheme(textColor),
    extensions: sidebarExtensionsTheme(hasBorder, mainColor, opacity),
    popupMenuTheme: sidebarPopupMenuTheme(mainColor, dialogColor),
    textTheme: sidebarTextTheme(mainColor, textColor),
    sliderTheme: sidebarSliderTheme(textColor),
    dialogTheme: sidebarDialogTheme(mainColor, dialogColor),
    checkboxTheme: sidebarCheckboxTheme(mainColor, textColor, opacity),
    primaryColor: mainColor,
    secondaryHeaderColor: mainColor.shade600,
    dividerTheme: sidebarDividerTheme(mainColor),
    radioTheme: sidebarRadioTheme(dialogColor),
    iconButtonTheme: sidebarIconButtonTheme(mainColor, textColor),
    inputDecorationTheme: sidebarInputDecorationTheme(mainColor),
    switchTheme: sidebarSwitchTheme(mainColor, textColor, opacity),
  );
}
