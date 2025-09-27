import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/features/items/domain/repositories/items_repo.dart';

@injectable
class ItemsClearAll {
  final ItemsRepo repository;

  ItemsClearAll(this.repository);

  Future<Either<Error, void>> call() async {
    return await repository.clearAll();
  }
}
