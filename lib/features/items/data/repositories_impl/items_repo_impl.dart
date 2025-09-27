import 'package:dartz/dartz.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/core/error/warnings.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';
import 'package:windows_widgets/features/items/domain/repositories/items_repo.dart';

@Injectable(as: ItemsRepo)
class ItemsRepoImpl with LogLayerMixin implements ItemsRepo {
  static final box = Hive.box<AppItem>(kHiveBox.items);

  @override
  Future<Either<Error, void>> add(AppItem item) async {
    try {
      await box.put(item.id, item);

      logSuccess('Item added', [item.name, item.type.name, item.path, item.id]);
      return const Right(null);
    } catch (e) {
      return Left(ItemsAddFailure(e));
    }
  }

  @override
  Future<Either<Error, List<AppItem>>> getAll() async {
    try {
      final items = box.values.toList();

      logSuccess('${items.length} Items Fetched');
      return Right(items);
    } catch (e) {
      return Left(ItemsGetAllFailure(e));
    }
  }

  @override
  Future<Either<Error, void>> remove(AppItem item) async {
    try {
      if (!box.containsKey(item.id)) {
        return Left(ItemsNotFoundWarning('Item: ${item.name}, id: ${item.id} is null'));
      }

      await box.delete(item.id);

      logSuccess('Item removed', [item.name, item.type.name, item.path, item.id]);

      return const Right(null);
    } catch (e) {
      return Left(ItemsRemoveFailure(e));
    }
  }

  @override
  Future<Either<Error, void>> update(AppItem item) async {
    try {
      if (!box.containsKey(item.id)) {
        return Left(ItemsNotFoundWarning('Item: ${item.name}, id: ${item.id} is null'));
      }

      await box.put(item.id, item);

      logSuccess('Item updated', [item.name, item.type.name, item.path, item.id]);
      return const Right(null);
    } catch (e) {
      return Left(ItemsUpdateFailure(e));
    }
  }

  @override
  Future<Either<Error, void>> clearAll() async {
    try {
      await box.clear();

      logSuccess('Items cleared');
      return const Right(null);
    } catch (e) {
      return Left(ItemsClearAllFailure(e));
    }
  }

  @override
  Future<Either<Error, void>> reorderDone(List<AppItem> items) async {
    try {
      await box.clear();

      if (items.isEmpty) {
        return const Right(null);
      }

      final itemsMap = <int, AppItem>{};
      for (final item in items) {
        itemsMap[item.id] = item;
      }

      await box.putAll(itemsMap);

      logSuccess('Items reordered');
      return const Right(null);
    } catch (e) {
      return Left(ItemsReorderDoneFailure(e));
    }
  }
}
