import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';

abstract class PrefsStates {}

class PrefsInit extends PrefsStates {}

class PrefsLoading extends PrefsStates {}

class PrefsLoaded extends PrefsStates {
  final Prefs prefs;

  PrefsLoaded({required this.prefs});
}

class PrefsError extends PrefsStates with LogLayerMixin {
  final String message;

  PrefsError({required this.message});
}
