import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/utils/windows_utils.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';
import 'package:windows_widgets/features/shared/domain/usecases/prefs_load.dart';
import 'package:windows_widgets/features/shared/domain/usecases/prefs_update.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_states.dart';

@injectable
class PrefsCubit extends Cubit<PrefsStates> with LogLayerMixin {
  //use cases
  final PrefsLoad _repoLoad;
  final PrefsSave _repoSave;
  final WindowsUtils _windowsUtils;

  Prefs? prefs;
  Prefs? initPrefs;
  //preferred
  PrefsCubit(this._repoLoad, this._repoSave, this._windowsUtils) : super(PrefsInit());

  Future<void> init() async {
    logInfo(init);

    emit(PrefsLoading());

    await _repoLoad().then(
      (value) => value.fold((failure) => emit(PrefsError(message: failure.userMessage)), (loadedPrefs) async {
        prefs = loadedPrefs;
        initPrefs = loadedPrefs;
        await applyBackgroundEffect(
          prefs!.selectedBackgroundEffect,
          kPrefsInit.selectedBackgroundEffect,
          isDark: prefs!.selectedTheme == 1,
        );

        emit(PrefsLoaded(prefs: prefs!));
      }),
    );
  }

  Future<void> applyBackgroundEffect(int effect, int oldEffect, {bool isDark = false}) async {
    logInfo(applyBackgroundEffect, ['effect: $effect']);

    try {
      switch (effect) {
        case 0:
          await _windowsUtils.transparent();
          break;
        case 1:
          await _windowsUtils.blur();
          break;
        case 2:
          await _windowsUtils.acrylic(dark: isDark);
          break;
        case 3:
          await _windowsUtils.mica(dark: isDark);
          break;

        default:
          await _windowsUtils.transparent();
      }
    } catch (e) {
      //revert back
      update(prefs!.copyWith(selectedBackgroundEffect: oldEffect));
    }
  }

  //save prefs to local db
  Future<void> save(Prefs newPrefs) async {
    logInfo(save);

    emit(PrefsLoading());

    await _repoSave(newPrefs).then((value) {
      value.fold(
        (failure) {
          prefs = initPrefs;
          emit(PrefsLoaded(prefs: initPrefs!));
        },
        (_) async {
          prefs = newPrefs;
          initPrefs = newPrefs;
          await Future.delayed(const Duration(milliseconds: 300));
          emit(PrefsLoaded(prefs: newPrefs));
        },
      );
    });
  }

  //update locally
  void update(Prefs newPrefs) {
    logInfo(update);
    prefs = newPrefs;
    emit(PrefsLoaded(prefs: newPrefs));
  }
}
