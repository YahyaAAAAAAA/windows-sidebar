import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';
import 'package:windows_widgets/features/shared/domain/repositories/prefs_repo.dart';

@injectable
class PrefsLoad {
  final PrefsRepo repository;

  PrefsLoad(this.repository);

  Future<Either<Error, Prefs>> call() async {
    return await repository.load();
  }
}
