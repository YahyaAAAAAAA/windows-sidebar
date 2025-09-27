import 'package:dartz/dartz.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';

abstract class ItemsRepo {
  Future<Either<Error, void>> add(AppItem item);

  Future<Either<Error, void>> remove(AppItem item);

  Future<Either<Error, void>> update(AppItem updatedItem);

  Future<Either<Error, List<AppItem>>> getAll();

  Future<Either<Error, void>> clearAll();

  Future<Either<Error, void>> reorderDone(List<AppItem> items);
}
