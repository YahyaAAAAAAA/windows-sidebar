import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';
import 'package:windows_widgets/features/shared/domain/repositories/prefs_repo.dart';

@injectable
class PrefsSave {
  final PrefsRepo repository;

  PrefsSave(this.repository);

  Future<Either<Error, void>> call(Prefs prefs) async {
    return await repository.save(prefs);
  }
}
