import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/prefs_repo.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/cubits/prefs/prefs_states.dart';

class PrefsCubit extends Cubit<PrefsStates> {
  final PrefsRepo prefsRepo;

  PrefsCubit({
    required this.prefsRepo,
  }) : super(PrefsInit()) {
    getPrefs();
  }

  Future<void> getPrefs() async {
    emit(PrefsLoading());
    try {
      final prefs = await prefsRepo.load();

      if (prefs.isBlurred) {
        await WindowUtils.blur();
      } else {
        await WindowUtils.transparent();
      }

      emit(PrefsLoaded(prefs: prefs));
    } catch (e) {
      emit(PrefsError(message: e.toString()));
    }
  }

  Future<void> updatePrefs(Prefs prefs) async {
    emit(PrefsLoading());
    try {
      await prefsRepo.update(prefs);

      emit(PrefsLoaded(prefs: prefs));
    } catch (e) {
      emit(PrefsError(message: e.toString()));
    }
  }

  Future<void> setOpacity(Prefs prefs) async {
    emit(PrefsLoading());
    try {
      emit(PrefsLoaded(prefs: prefs));
    } catch (e) {
      emit(PrefsError(message: e.toString()));
    }
  }

  Future<void> setTheme(Prefs prefs) async {
    emit(PrefsLoading());
    try {
      emit(PrefsLoaded(prefs: prefs));
    } catch (e) {
      emit(PrefsError(message: e.toString()));
    }
  }
}
