import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';
import 'package:windows_widgets/features/items/domain/repositories/items_repo.dart';

@injectable
class ItemsReorderDone {
  final ItemsRepo repository;

  ItemsReorderDone(this.repository);

  Future<Either<Error, void>> call(List<AppItem> items) async {
    return await repository.reorderDone(items);
  }
}
