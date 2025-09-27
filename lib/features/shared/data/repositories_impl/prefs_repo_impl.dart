import 'package:dartz/dartz.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';
import 'package:windows_widgets/features/shared/domain/repositories/prefs_repo.dart';

@Injectable(as: PrefsRepo)
class PrefsRepoImpl with LogLayerMixin implements PrefsRepo {
  static final prefsBox = Hive.box(kHiveBox.prefs);

  @override
  Future<Either<Error, Prefs>> load() async {
    try {
      // forceException();
      //doubles
      final windowHeight = await prefsBox.get('windowHeight') ?? kWindowSize.height;
      final windowWidth = await prefsBox.get('windowWidth') ?? kWindowSize.width;
      final backgroundOpacity = prefsBox.get('backgroundOpacity') ?? kPrefsInit.backgroundOpacity;

      //ints
      final selectedTheme = await prefsBox.get('selectedTheme') ?? kPrefsInit.theme;

      final selectedBackgroundEffect = await prefsBox.get('selectedBackgroundEffect') ?? kPrefsInit.selectedBackgroundEffect;
      final selectedAccentColor = await prefsBox.get('selectedAccentColor') ?? kPrefsInit.selectedAccentColor;

      //bools
      final hasBorder = await prefsBox.get('hasBorder') ?? kPrefsInit.hasBorder;
      final mixBackgroundWithAccent = await prefsBox.get('mixBackgroundWithAccent') ?? kPrefsInit.mixBackgroundWithAccent;
      final useSystemAccentColor = await prefsBox.get('useSystemAccentColor') ?? kPrefsInit.useSystemAccentColor;

      logSuccess('Prefs loaded');
      return Right(
        Prefs(
          backgroundOpacity: backgroundOpacity,
          selectedTheme: selectedTheme,
          selectedBackgroundEffect: selectedBackgroundEffect,
          selectedAccentColor: selectedAccentColor,
          hasBorder: hasBorder,
          windowHeight: windowHeight,
          windowWidth: windowWidth,
          mixBackgroundWithAccent: mixBackgroundWithAccent,
          useSystemAccentColor: useSystemAccentColor,
        ),
      );
    } catch (e) {
      return Left(PrefsLoadFailure(e));
    }
  }

  @override
  Future<Either<Error, void>> save(Prefs preferences) async {
    try {
      await prefsBox.putAll(preferences.toJSON());

      logSuccess('Prefs saved');
      return const Right(null);
    } catch (e) {
      return Left(PrefsSaveFailure(e));
    }
  }
}
