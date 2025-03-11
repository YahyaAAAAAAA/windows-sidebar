import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/config/enums/open_item_command_type.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';
import 'package:windows_widgets/config/utils/transition_animation.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';
import 'package:windows_widgets/features/main_sidebar/domain/side_items_repo.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_states.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/dialogs/change_item_name_dialog.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/dialogs/change_item_open_command_dialog.dart';

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

  //change item name
  Future<void> editItemNameDialog({
    required BuildContext context,
    required TextEditingController controller,
    required SideItem item,
  }) async {
    //set init name
    controller.text = item.name;
    String? errorText;

    //open dialog
    await context.dialog(
      barrierDismissible: false,
      transitionBuilder: TransitionAnimations.slideFromBottom,
      pageBuilder: (context, _, __) => StatefulBuilder(
        builder: (context, setState) => ChangeItemNameDialog(
          controller: controller,
          errorText: errorText,
          labelText: '${item.type.name.capitalize()} Name',
          hintText: '${item.type.name.capitalize()} new name',
          onCancelPressed: () {
            controller.clear();
            context.pop();
          },
          onSavePressed: () {
            if (controller.text.isEmpty) {
              errorText = 'Please enter a name';
              setState(() {});
              return;
            }
            item.name = controller.text;
            context.pop();
          },
        ),
      ),
    );

    //if name empty/user canceled do nothing
    if (controller.text.isEmpty) return;

    //update item, clear controller
    await updateItem(item.id!, item);
    controller.clear();
  }

  //change item name
  Future<void> editItemOpenCommandDialog({
    required BuildContext context,
    required SideItem item,
  }) async {
    String initCommand = item.command;
    bool shouldUpdate = false;

    //open dialog
    await context.dialog(
      barrierDismissible: false,
      transitionBuilder: TransitionAnimations.slideFromBottom,
      pageBuilder: (context, _, __) => StatefulBuilder(
        builder: (context, setState) => ChangeItemOpenCommandDialog(
          commandType: item.command,
          onExplorerSelected: (command) {
            item.command = SideItemOpenCommandType.explorer.name;
            setState(() {});
          },
          onStartSelected: (command) {
            item.command = SideItemOpenCommandType.start.name;
            setState(() {});
          },
          onCancelPressed: () {
            shouldUpdate = false;
            item.command = initCommand;
            context.pop();
          },
          onSavePressed: () {
            shouldUpdate = true;
            context.pop();
          },
        ),
      ),
    );
    //user canceled
    if (!shouldUpdate) return;

    //update item
    await updateItem(item.id!, item);
  }
}
