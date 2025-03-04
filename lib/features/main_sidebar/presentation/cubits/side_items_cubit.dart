import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';
import 'package:windows_widgets/features/main_sidebar/domain/side_items_repo.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_states.dart';

class SideItemsCubit extends Cubit<SideItemsStates> {
  final SideItemsRepo itemsRepo;
  List<SideItem> _items = [];

  SideItemsCubit({required this.itemsRepo}) : super(SideItemsInit()) {
    // clearAll();
    initializeItems();
  }

  Future<void> initializeItems() async {
    emit(SideItemsLoading());
    try {
      _items = await itemsRepo.getAllItems();

      emit(SideItemsLoaded(items: _items));
    } catch (e) {
      emit(SideItemsError(message: e.toString()));
    }
  }

  //add item
  Future<void> addItem(SideItem item) async {
    emit(SideItemsLoading());
    try {
      await itemsRepo.addItem(item);
      _items.add(item);

      emit(SideItemsLoaded(items: _items));
    } catch (e) {
      emit(SideItemsError(message: e.toString()));
    }
  }

  //remove item
  Future<void> removeItem(int id) async {
    emit(SideItemsLoading());
    try {
      await itemsRepo.removeItem(id);
      _items.removeWhere((item) => item.id == id);

      emit(SideItemsLoaded(items: _items));
    } catch (e) {
      emit(SideItemsError(message: e.toString()));
    }
  }

  //update item
  Future<void> updateItem(int id, SideItem updatedItem) async {
    emit(SideItemsLoading());
    try {
      await itemsRepo.updateItem(id, updatedItem);
      _items[_items.indexWhere((item) => item.id == id)] = updatedItem;

      emit(SideItemsLoaded(items: _items));
    } catch (e) {
      emit(SideItemsError(message: e.toString()));
    }
  }

  //clear box and list
  Future<void> clearAll() async {
    emit(SideItemsLoading());
    try {
      itemsRepo.clearAllItems();
      _items.clear();

      emit(SideItemsLoaded(items: _items));
    } catch (e) {
      emit(SideItemsError(message: e.toString()));
    }
  }

  Future<void> onReorder(int oldIndex, int newIndex) async {
    emit(SideItemsLoading());
    try {
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);

      emit(SideItemsLoaded(items: _items));
    } catch (e) {
      emit(SideItemsError(message: e.toString()));
    }
  }

  //sync local list to Hive list
  Future<void> onReorderDone() async {
    emit(SideItemsLoading());
    try {
      final items = await itemsRepo.getAllItems();

      if (!listEquals(items, _items)) {
        await itemsRepo.onReorderDone(_items);
        debugPrint("list saved");
      }

      emit(SideItemsLoaded(items: _items));
    } catch (e) {
      emit(SideItemsError(message: e.toString()));
    }
  }
}
