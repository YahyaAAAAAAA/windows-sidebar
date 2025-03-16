import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/prefs_repo.dart';

class HivePrefsRepo implements PrefsRepo {
  static final prefsBox = Hive.box('prefsBox');

  @override
  Future<Prefs> load() async {
    final backgroundOpacity =
        prefsBox.get('backgroundOpacity') ?? kInitBackgroundOpacity;
    final selectedTheme =
        await prefsBox.get('selectedTheme') ?? kInitSelectedTheme;
    final isBlurred = await prefsBox.get('isBlurred') ?? kInitIsBlurred;
    final hasBorder = await prefsBox.get('hasBorder') ?? kInitHasBorder;
    final windowHeight = await prefsBox.get('windowHeight') ?? kWindowHeight;
    final scaffoldPadding =
        await prefsBox.get('scaffoldPadding') ?? kInitScaffoldPadding;

    return Prefs(
      backgroundOpacity: backgroundOpacity,
      selectedTheme: selectedTheme,
      isBlurred: isBlurred,
      hasBorder: hasBorder,
      windowHeight: windowHeight,
      scaffoldPadding: scaffoldPadding,
    );
  }

  @override
  Future<void> update(Prefs preferences) async {
    await prefsBox.putAll(preferences.toJSON());
  }
}
