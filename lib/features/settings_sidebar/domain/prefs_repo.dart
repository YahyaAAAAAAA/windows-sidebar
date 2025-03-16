import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';

abstract class PrefsRepo {
  Future<Prefs> load();
  Future<void> update(Prefs prefs);
}
