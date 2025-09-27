import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';

class Dummy {
  static Prefs prefs = Prefs(
    selectedTheme: kPrefsInit.theme,
    backgroundOpacity: kPrefsInit.backgroundOpacity,
    windowHeight: kWindowSize.height.toDouble(),
    selectedBackgroundEffect: kPrefsInit.selectedBackgroundEffect,
    selectedAccentColor: kPrefsInit.selectedAccentColor,
    hasBorder: kPrefsInit.hasBorder,
    mixBackgroundWithAccent: kPrefsInit.mixBackgroundWithAccent,
    useSystemAccentColor: kPrefsInit.useSystemAccentColor,
    windowWidth: kWindowSize.width,
  );
}
