import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/packages/spring_curve/spring_curve.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/picker.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/app/buttons/ghost_button.dart';
import 'package:windows_widgets/core/widgets/global_loading.dart';
import 'package:windows_widgets/core/widgets/horizontal_scroll_behavior.dart';
import 'package:windows_widgets/core/widgets/item_context_menu.dart';
import 'package:windows_widgets/core/widgets/smooth_list.dart';
import 'package:windows_widgets/features/items/domain/models/app_file.dart';
import 'package:windows_widgets/features/items/domain/models/app_folder.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';
import 'package:windows_widgets/features/items/domain/models/app_url.dart';
import 'package:windows_widgets/features/items/presentation/components/dialogs/item_info_dialog.dart';
import 'package:windows_widgets/features/items/presentation/components/item_card.dart';
import 'package:windows_widgets/features/items/presentation/cubits/items_cubit.dart';
import 'package:windows_widgets/features/items/presentation/cubits/items_states.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data.dart';
import 'package:windows_widgets/features/shared/presentation/components/window_topbar.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/window_cubit.dart';

class ItemsWindowWidget extends StatefulWidget {
  final int id;

  const ItemsWindowWidget({super.key, required this.id});

  @override
  State<ItemsWindowWidget> createState() => _ItemsWindowWidgetState();
}

class _ItemsWindowWidgetState extends State<ItemsWindowWidget> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  bool canDrag = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    urlController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  WindowCubit get windowCubit => context.read<WindowCubit>();
  ItemsCubit get itemsCubit => context.read<ItemsCubit>();
  WindowData? get window => windowCubit.getWindowById(widget.id);

  @override
  Widget build(BuildContext context) {
    return WindowTopBar(
      onClose: () => windowCubit.closeWindow(window),
      onMinimize: () => windowCubit.restoreWindow(window),
      titleChildren: [
        GhostButton(
          onPressed: () async {
            AppUrl? url = await Picker.pickUrl(context: context, controller: urlController);
            if (url != null) {
              itemsCubit.add(url);
            }
          },
          width: kBarButton.width,
          height: kBarButton.height,

          child: Icon(FluentIcons.link_add_24_regular, size: kIconSize.micro),
        ),
        GhostButton(
          onPressed: () async {
            AppFile? file = await Picker.pickFile();
            if (file != null) {
              itemsCubit.add(file);
            }
          },
          width: kBarButton.width,
          height: kBarButton.height,
          child: Icon(FluentIcons.document_add_24_regular, size: kIconSize.micro),
        ),
        GhostButton(
          onPressed: () async {
            AppFolder? folder = await Picker.pickFolder();
            if (folder != null) {
              itemsCubit.add(folder);
            }
          },
          width: kBarButton.width,
          height: kBarButton.height,
          child: Icon(FluentIcons.folder_add_24_regular, size: kIconSize.micro),
        ),
      ],
      child: BlocBuilder<ItemsCubit, ItemsStates>(
        builder: (context, state) {
          //loaded
          if (state is ItemsLoaded) {
            final items = state.items;

            //empty
            if (items.isEmpty) {
              return AppContainer(
                isPanel: true,
                height: kItemButton.height + kGap.medium,
                width: kItemButton.width + kItemButton.width + kItemButton.width,
                padding: kPadding.small.pAll,
                alignment: Alignment.center,
                child: const LabelMediumText('Nothing here :('),
              );
            }
            return AppContainer(
              height: kItemButton.height + kGap.medium,
              width: (kItemButton.width * items.length) + kGap.medium,
              padding: kPadding.small.pAll,
              curve: ElegantSpring.windows,
              duration: kDuration.long,
              alignment: Alignment.center,
              constraints: BoxConstraints(minWidth: kItemButton.width * 3),
              isAnimated: true,
              isPanel: true,
              child: ScrollConfiguration(
                behavior: HorizontalScrollBehavior(),
                child: SmoothList(
                  controller: scrollController,
                  child: AnimatedReorderableListView(
                    controller: scrollController,
                    items: items,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    isSameItem: (a, b) => a.id == b.id,
                    enterTransition: [Landing()],
                    exitTransition: [Landing()],
                    insertDuration: kDuration.medium,
                    removeDuration: kDuration.medium,
                    dragStartDelay: kDuration.medium,
                    buildDefaultDragHandles: false,
                    longPressDraggable: canDrag,
                    nonDraggableItems: canDrag ? List<AppItem>.empty() : items,
                    removeItemBuilder: (child, animation) => 0.width,
                    onReorder: (oldIndex, newIndex) => itemsCubit.reorder(oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ItemCard(
                        key: ValueKey(item.id),
                        item: item,
                        isExpanded: isExpanded,
                        canDrag: canDrag,
                        onEnter: (_) => itemsCubit.updateHover(item, true),
                        onExit: (_) => itemsCubit.updateHover(item, false),
                        onFocusChange: (value) {
                          itemsCubit.updateFocus(item, value);
                          if (value) windowCubit.bringToFront(window);
                        },
                        onLeftClick: () => item.open(context),
                        onRightClick: (context, position) async => await itemContextMenu(
                          context,
                          position,
                          onInfo: () => showDialog(
                            context: context,
                            builder: (context) => ItemInfoDialog(item: item),
                          ),
                          onDelete: () {
                            itemsCubit.remove(item);
                          },
                          onNameEdit: () async =>
                              await itemsCubit.updateName(context: context, controller: itemNameController, item: item),
                          onCommandEdit: () async => await itemsCubit.updateCommand(context: context, item: item),
                          onOpenLocation: item is AppFile ? () => item.openLocation(context) : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          }

          //error
          if (state is ItemsFailure) {
            return AppContainer(
              isPanel: true,
              height: kItemButton.height + kGap.medium,
              width: kItemButton.width + kItemButton.width + kItemButton.width,
              padding: kPadding.small.pAll,
              alignment: Alignment.center,
              child: const LabelMediumText('There was an error'),
            );
          }

          //loading
          return AppContainer(
            isPanel: true,
            width: kItemButton.width + kItemButton.width + kItemButton.width,
            height: kItemButton.height + kGap.medium,
            padding: kPadding.small.pAll,
            child: GlobalLoading(maxWidth: kItemButton.width),
          );
        },
      ),
    );
  }
}
