import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';

abstract class SideItemsRepo {
  Future<void> addItem(SideItem item);

  Future<void> removeItem(int id);

  Future<void> updateItem(int key, SideItem updatedItem);

  Future<List<SideItem>> getAllItems();

  Future<void> clearAllItems();

  Future<void> onReorderDone(List<SideItem> items);
}
