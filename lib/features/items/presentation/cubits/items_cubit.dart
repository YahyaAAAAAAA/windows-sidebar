import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/utils/toast.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';
import 'package:windows_widgets/features/items/domain/usecases/items_add.dart';
import 'package:windows_widgets/features/items/domain/usecases/items_clear_all.dart';
import 'package:windows_widgets/features/items/domain/usecases/items_get_all.dart';
import 'package:windows_widgets/features/items/domain/usecases/items_remove.dart';
import 'package:windows_widgets/features/items/domain/usecases/items_reorder_done.dart';
import 'package:windows_widgets/features/items/domain/usecases/items_update.dart';
import 'package:windows_widgets/features/items/presentation/components/dialogs/item_name_edit_dialog.dart';
import 'package:windows_widgets/features/items/presentation/components/dialogs/item_open_command_edit_dialog.dart';
import 'package:windows_widgets/features/items/presentation/cubits/items_states.dart';

/* 

  general approach for this file:
  1- update the user UI (the state list) first
  2- then reflect changes in the db
  3- if error emit it, otherwise do nothing

*/

@injectable
class ItemsCubit extends Cubit<ItemsStates> with LogLayerMixin {
  //use cases
  final ItemsAdd _repoAdd;
  final ItemsRemove _repoRemove;
  final ItemsUpdate _repoUpdate;
  final ItemsReorderDone _repoReorderDone;
  final ItemsGetAll _repoGetAll;
  final ItemsClearAll _repoClearAll;

  //FIXME either fix or remove
  Map<int, int>? _idToIndexCache;
  bool _isListDirty = false;

  ItemsCubit(
    this._repoAdd,
    this._repoRemove,
    this._repoUpdate,
    this._repoReorderDone,
    this._repoGetAll,
    this._repoClearAll,
  ) : super(ItemsInit()) {
    init();
  }

  Future<void> init() async {
    logInfo(init);
    emit(ItemsLoading());

    await _repoGetAll().then(
      (value) => value.fold((error) => emit(ItemsFailure(message: error)), (items) => emit(ItemsLoaded(items: items))),
    );
  }

  //---list updates---

  Future<void> add(AppItem item) async {
    logInfo(add, [item.name, item.type.name, item.path, item.id]);

    final items = _getCurrentItems();
    if (items == null) {
      logWarning('Tried to add null item', item.logParams);
      Toast.warning('Can\'t add items right now');
      return;
    }

    items.add(item);
    emit(ItemsLoaded(items: items));

    await _repoAdd(item).then(
      (value) => value.fold((_) {
        //recoverable error, will be logged and displayed (Error object will do that)
        items.remove(item);
        emit(ItemsLoaded(items: items));
      }, (_) => null),
    );
  }

  Future<void> remove(AppItem item) async {
    logInfo(remove, item.logParams);

    final items = _getCurrentItems();
    if (items == null) {
      logWarning('Tried to remove null item', item.logParams);
      Toast.warning('Can\'t remove items right now');
      return;
    }

    final removedIndex = items.indexWhere((i) => i.id == item.id);
    items.removeAt(removedIndex);
    emit(ItemsLoaded(items: items));

    await _repoRemove(item).then(
      (value) => value.fold((_) {
        if (removedIndex != -1) {
          items.insert(removedIndex, item);
          emit(ItemsLoaded(items: items));
        }
      }, (_) => null),
    );
  }

  //clear box and list
  Future<void> clear() async {
    logInfo(clear);

    final items = _getCurrentItems();
    if (items == null) {
      logWarning('Tried to clear null list of items');
      Toast.warning('Can\'t clear items right now');
      return;
    }

    final originalItems = List<AppItem>.from(items);
    items.clear();
    emit(ItemsLoaded(items: items));

    await _repoClearAll().then(
      (value) => value.fold((_) {
        items.addAll(originalItems);
        emit(ItemsLoaded(items: items));
      }, (_) => null),
    );
  }

  //reorder local list
  Future<void> reorder(int oldIndex, int newIndex) async {
    final items = _getCurrentItems();
    if (items == null) {
      logWarning('Tried to reorder null items');
      Toast.warning('Can\'t reorder items right now');
      return;
    }

    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    _isListDirty = true;
    emit(ItemsLoaded(items: items));
  }

  //sync local list to Hive list
  Future<void> reorderDone() async {
    logInfo(reorderDone);

    final currentItems = _getCurrentItems();
    if (currentItems == null) {
      logWarning('Tried to reorder null items');
      Toast.warning('Can\'t reorder items right now');
      return;
    }

    if (!_isListDirty) return;

    final originalItems = List<AppItem>.from(currentItems);
    ItemsLoaded(items: currentItems);

    //if list is changed, sync lists
    await _repoReorderDone(
      currentItems,
    ).then((value) => value.fold((_) => emit(ItemsLoaded(items: originalItems)), (_) => _isListDirty = false));
  }

  //---item updates---

  //toggle hover
  void updateHover(AppItem? item, bool isHovered) {
    if (item == null) return;

    _updateItem(item, (item) => item.copyWith(isHovered: isHovered), shouldSave: false);
  }

  void updateFocus(AppItem? item, bool hasFocus) {
    if (item == null) return;

    _updateItem(item, (item) => item.copyWith(hasFocus: hasFocus), shouldSave: false);
  }

  //change item name
  Future<void> updateName({
    required BuildContext context,
    required TextEditingController controller,
    required AppItem item,
  }) async {
    logInfo(updateName);

    //set init name
    controller.text = item.name;
    String initName = item.name;
    String? errorText;

    //open dialog
    await context.dialog(
      barrierDismissible: false,
      pageBuilder: (context, _, _) => StatefulBuilder(
        builder: (context, setState) => ItemNameEditDialog(
          controller: controller,
          errorText: errorText,
          labelText: '${item.type.name.capitalize()} Name',
          hintText: '${item.type.name.capitalize()} new name',
          onCancelPressed: () {
            controller.clear();
            context.pop();
          },
          onSavePressed: () async {
            if (controller.text.trim().isEmpty) {
              errorText = 'Please enter a name';
              setState(() {});
              return;
            }

            if (controller.text.trim() != initName) {
              await _updateItem(item, (item) => item.copyWith(name: controller.text.trim()));
            }

            context.pop();
          },
        ),
      ),
    );
  }

  //change item name
  Future<void> updateCommand({required BuildContext context, required AppItem item}) async {
    logInfo(updateCommand);

    String initCommand = item.command;
    String newCommand = item.command;

    await context.dialog(
      barrierDismissible: false,
      pageBuilder: (context, _, _) => StatefulBuilder(
        builder: (context, setState) => ItemOpenCommandEditDialog(
          commandType: newCommand,
          onExplorerSelected: (command) => setState(() => newCommand = command!),
          onStartSelected: (command) => setState(() => newCommand = command!),
          onCancelPressed: () => context.pop(),
          onSavePressed: () async {
            if (initCommand != newCommand) {
              await _updateItem(item, (item) => item.copyWith(command: newCommand));
            }
            context.pop();
          },
        ),
      ),
    );
  }

  //---private helper methods---

  List<AppItem>? _getCurrentItems() {
    final currentState = state;

    if (currentState is! ItemsLoaded) return null;

    return currentState.items;
  }

  int _findItemIndex(int itemId) {
    //cache available
    if (_idToIndexCache != null) {
      return _idToIndexCache![itemId] ?? -1;
    }

    final currentState = state;

    if (currentState is! ItemsLoaded) return -1;

    //build cache
    final items = currentState.items;
    _idToIndexCache = <int, int>{};

    for (int i = 0; i < items.length; i++) {
      _idToIndexCache![items[i].id] = i;
    }

    return _idToIndexCache![itemId] ?? -1;
  }

  Future<void> _updateItem(AppItem newItem, AppItem Function(AppItem) updater, {bool shouldSave = true}) async {
    final index = _findItemIndex(newItem.id);
    if (index == -1 || state is! ItemsLoaded) return;

    final items = _getCurrentItems();

    if (items == null) {
      logWarning('Tried to update null item');
      Toast.warning('Can\'t update item right now');
      return;
    }

    final originalItem = items[index];
    final updatedItem = updater(originalItem);

    //no change
    if (originalItem == updatedItem) return;

    //update ui & cache
    items[index] = updatedItem;
    emit(ItemsLoaded(items: items));

    if (shouldSave) {
      await _repoUpdate(updatedItem).then(
        (value) => value.fold((_) {
          items[index] = originalItem;

          emit(ItemsLoaded(items: items));
        }, (_) => null),
      );
    }
  }

  void _clearCache() {
    _idToIndexCache = null;
  }

  @override
  void emit(ItemsStates state) {
    //clear cache when state changes
    _clearCache();
    super.emit(state);
  }
}
