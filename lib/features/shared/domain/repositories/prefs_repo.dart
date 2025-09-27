import 'package:dartz/dartz.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';

abstract class PrefsRepo {
  Future<Either<Error, Prefs>> load();
  Future<Either<Error, void>> save(Prefs prefs);
}
