import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/prefs_repo.dart';

class HivePrefsRepo implements PrefsRepo {
  static final box = Hive.box('prefsBox');

  double backgroundOpacity = 1;
  bool isBlurred = false;
  int selectedTheme = 0;

  @override
  Future<Prefs> load() async {
    backgroundOpacity = (await box.get('backgroundOpacity')) ?? 1;
    isBlurred = (await box.get('isBlurred')) ?? false;
    selectedTheme = (await box.get('selectedTheme')) ?? 0;

    return Prefs(
      backgroundOpacity: backgroundOpacity,
      selectedTheme: selectedTheme,
      isBlurred: isBlurred,
    );
  }

  @override
  Future<void> update(Prefs prefs) async {
    await box.put('backgroundOpacity', prefs.backgroundOpacity);
    await box.put('isBlurred', prefs.isBlurred);
    await box.put('selectedTheme', prefs.selectedTheme);
  }
}
