import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';
import 'package:windows_widgets/features/items/domain/repositories/items_repo.dart';

@injectable
class ItemsAdd {
  final ItemsRepo repository;

  ItemsAdd(this.repository);

  Future<Either<Error, void>> call(AppItem item) async {
    return await repository.add(item);
  }
}
