import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';
import 'package:windows_widgets/features/items/domain/repositories/items_repo.dart';

@injectable
class ItemsGetAll {
  final ItemsRepo repository;

  ItemsGetAll(this.repository);

  Future<Either<Error, List<AppItem>>> call() async {
    return await repository.getAll();
  }
}
