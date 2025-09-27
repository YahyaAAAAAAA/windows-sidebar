import 'package:windows_widgets/features/shared/domain/models/prefs.dart';

bool prefsIdentical(Prefs oldPrefs, Prefs newPrefs) {
  return oldPrefs.selectedTheme == newPrefs.selectedTheme &&
      oldPrefs.backgroundOpacity == newPrefs.backgroundOpacity &&
      oldPrefs.selectedBackgroundEffect == newPrefs.selectedBackgroundEffect &&
      oldPrefs.selectedAccentColor == newPrefs.selectedAccentColor &&
      oldPrefs.hasBorder == newPrefs.hasBorder;
}
