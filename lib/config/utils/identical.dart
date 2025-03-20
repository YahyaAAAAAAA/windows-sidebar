import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';

bool prefsIdentical(Prefs oldPrefs, Prefs newPrefs) {
  return oldPrefs.selectedTheme == newPrefs.selectedTheme &&
      oldPrefs.backgroundOpacity == newPrefs.backgroundOpacity &&
      oldPrefs.windowHeight == newPrefs.windowHeight &&
      oldPrefs.isBlurred == newPrefs.isBlurred &&
      oldPrefs.hasBorder == newPrefs.hasBorder;
}
