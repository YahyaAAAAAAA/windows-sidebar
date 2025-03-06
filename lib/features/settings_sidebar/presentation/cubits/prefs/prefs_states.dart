import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';

abstract class PrefsStates {}

class PrefsInit extends PrefsStates {}

class PrefsLoading extends PrefsStates {}

class PrefsLoaded extends PrefsStates {
  final Prefs prefs;

  PrefsLoaded({required this.prefs});
}

class PrefsError extends PrefsStates {
  final String message;

  PrefsError({required this.message});
}
