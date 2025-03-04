import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';
import 'package:windows_widgets/features/main_sidebar/domain/side_items_repo.dart';

class HiveSideItemsRepo implements SideItemsRepo {
  static final box = Hive.box('sideItemsBox');

  //add a SideFolder or SideFile to the database
  @override
  Future<void> addItem(SideItem item) async {
    await box.add(item);
  }

  //get all SideItems (both SideFolder and SideFile) from the database
  @override
  Future<List<SideItem>> getAllItems() async {
    return box.values.cast<SideItem>().toList();
  }

  //get a specific SideItem by its id
  @override
  Future<void> removeItem(int id) async {
    final items = box.values.cast<SideItem>().toList();
    final itemToRemove = items.firstWhere((item) => item.id == id);
    final key = box.keyAt(items.indexOf(itemToRemove));

    await box.delete(key);
  }

  //update a SideItem in the database
  @override
  Future<void> updateItem(int id, SideItem updatedItem) async {
    final items = box.values.cast<SideItem>().toList();
    final itemToRemove = items.firstWhere((item) => item.id == id);
    final key = box.keyAt(items.indexOf(itemToRemove));

    await box.put(key, updatedItem);
  }

  //clear all items from the database
  @override
  Future<void> clearAllItems() async {
    await box.clear();
  }

  //sync lists
  @override
  Future<void> onReorderDone(List<SideItem> items) async {
    await box.clear();
    await box.addAll(items);
  }
}
