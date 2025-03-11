import 'package:shared_preferences/shared_preferences.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/prefs_repo.dart';

class SharedPrefsRepo implements PrefsRepo {
  static late final SharedPreferences prefs;

  @override
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<Prefs> load() async {
    final backgroundOpacity =
        prefs.getDouble('backgroundOpacity') ?? kInitBackgroundOpacity;
    final selectedTheme = prefs.getInt('selectedTheme') ?? kInitSelectedTheme;
    final isBlurred = prefs.getBool('isBlurred') ?? kInitIsBlurred;
    final hasBorder = prefs.getBool('hasBorder') ?? kInitHasBorder;
    final windowHeight = prefs.getDouble('windowHeight') ?? kWindowHeight;
    final scaffoldPadding =
        prefs.getDouble('scaffoldPadding') ?? kInitScaffoldPadding;

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
    await prefs.setDouble('backgroundOpacity', preferences.backgroundOpacity);
    await prefs.setInt('selectedTheme', preferences.selectedTheme);
    await prefs.setBool('isBlurred', preferences.isBlurred);
    await prefs.setBool('hasBorder', preferences.hasBorder);
    await prefs.setDouble('windowHeight', preferences.windowHeight);
    await prefs.setDouble('scaffoldPadding', preferences.scaffoldPadding);
  }
}
