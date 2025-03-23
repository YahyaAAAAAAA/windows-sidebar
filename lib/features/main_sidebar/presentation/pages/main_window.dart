import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/config/utils/widgets/app_scaffold.dart';
import 'package:windows_widgets/config/utils/widgets/global_loading.dart';
import 'package:windows_widgets/config/utils/widgets/right_click_menu.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_url.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_cubit.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_states.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/dialogs/item_info_dialog.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/footer_row.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/header_row.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/no_items_row.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_item_card.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/settings_window.dart';

class MainWindow extends StatefulWidget {
  final bool isExpanded;
  final bool isPinned;
  final bool shouldLoseFoucs;
  final VoidCallback toggleExpanded;
  final VoidCallback togglePin;
  final VoidCallback toggleShouldLoseFocus;

  const MainWindow({
    super.key,
    required this.isExpanded,
    required this.isPinned,
    required this.toggleExpanded,
    required this.togglePin,
    required this.shouldLoseFoucs,
    required this.toggleShouldLoseFocus,
  });

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow>
    with TickerProviderStateMixin, WindowListener, WindowAnimationUtilsMixin {
  late final SideItemsCubit sideItemsCubit;
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  bool canDrag = false;

  @override
  void initState() {
    super.initState();

    //cubits
    sideItemsCubit = context.read<SideItemsCubit>();
  }

  @override
  void dispose() {
    itemNameController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //logo & settings
          HeaderRow(
            isExpanded: widget.isExpanded,
            isPinned: widget.isPinned,
            onPinPressed: widget.togglePin,
            onReorderPressed: () async {
              setState(() => canDrag = !canDrag);

              if (!canDrag) {
                //save context 😑
                final currentContext = context;

                await sideItemsCubit.onReorderDone();

                //because "don't use BuildContext in async gaps" 😑
                if (currentContext.mounted) {
                  currentContext.showSnackBar('Done');
                }
              }
            },
            canDrag: canDrag,
            onSettingsPressed: () => context.push(
              SettingsWindow(),
            ),
            onExpandPressed: () async {
              widget.toggleExpanded();

              if (!widget.isExpanded) {
                animatePositionTo(WindowUtils.originalPosition +
                    Offset(kOnEnterRightExpand, 0));
              } else {
                animatePositionTo(
                    WindowUtils.originalPosition + Offset(kOnEnterRight, 0));
              }
            },
          ),

          SideDivider(isExpanded: widget.isExpanded),

          //files & folder list
          BlocConsumer<SideItemsCubit, SideItemsStates>(
            builder: (context, state) {
              if (state is SideItemsLoaded) {
                final items = state.items;
                if (items.isEmpty) {
                  return NoItemsRow(isExpanded: widget.isExpanded);
                }
                return Expanded(
                  child: AnimatedReorderableListView(
                    items: items,
                    isSameItem: (a, b) => a.id == b.id,
                    enterTransition: [SlideInDown()],
                    exitTransition: [SlideInUp()],
                    insertDuration: const Duration(milliseconds: 300),
                    removeDuration: const Duration(milliseconds: 300),
                    dragStartDelay: const Duration(milliseconds: 300),
                    buildDefaultDragHandles: canDrag,
                    longPressDraggable: false,
                    nonDraggableItems: canDrag ? List<SideItem>.empty() : items,
                    onReorder: (int oldIndex, int newIndex) =>
                        sideItemsCubit.onReorder(oldIndex, newIndex),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      if (item is SideFolder) {
                        return SideItemCard.folder(
                          key: ValueKey(item.id),
                          isExpanded: widget.isExpanded,
                          index: index,
                          folder: item,
                          onEnter: (_) => setState(
                              () => item.localIcon = Custom.folder_open_fill),
                          onExit: (_) => setState(
                              () => item.localIcon = Custom.folder_fill),
                          onLeftClick: () => item.open(context),
                          onRightClick: (context, position) async =>
                              await showContextMenu(
                            context,
                            position,
                            widget.isExpanded,
                            onInfo: () => showDialog(
                              context: context,
                              builder: (context) => ItemInfoDialog(item: item),
                            ),
                            onDelete: () => sideItemsCubit.removeItem(item.id!),
                            onNameEdit: () {
                              sideItemsCubit.editItemNameDialog(
                                context: context,
                                controller: itemNameController,
                                item: item,
                              );
                            },
                            onCommandEdit: () =>
                                sideItemsCubit.editItemOpenCommandDialog(
                              context: context,
                              item: item,
                            ),
                          ),
                        );
                      }
                      if (item is SideFile) {
                        return SideItemCard.file(
                          key: ValueKey(item.id),
                          isExpanded: widget.isExpanded,
                          index: index,
                          file: item,
                          onEnter: (_) => setState(() => item.scale = 1.8),
                          onExit: (_) => setState(() => item.scale = 1.7),
                          onLeftClick: () => item.open(context),
                          onRightClick: (context, position) async =>
                              await showContextMenu(
                            context,
                            position,
                            widget.isExpanded,
                            onInfo: () => showDialog(
                              context: context,
                              builder: (context) => ItemInfoDialog(item: item),
                            ),
                            onOpenLocation: () => item.openLocation(context),
                            onDelete: () => sideItemsCubit.removeItem(item.id!),
                            onNameEdit: () => sideItemsCubit.editItemNameDialog(
                              context: context,
                              controller: itemNameController,
                              item: item,
                            ),
                            onCommandEdit: () =>
                                sideItemsCubit.editItemOpenCommandDialog(
                              context: context,
                              item: item,
                            ),
                          ),
                        );
                      }
                      if (item is SideUrl) {
                        return SideItemCard.url(
                          key: ValueKey(item.id),
                          url: item,
                          isExpanded: widget.isExpanded,
                          index: index,
                          onEnter: (_) => setState(() => item.scale = 1.8),
                          onExit: (_) => setState(() => item.scale = 1.7),
                          onLeftClick: () => item.open(context),
                          onRightClick: (context, position) async =>
                              await showContextMenu(
                            context,
                            position,
                            widget.isExpanded,
                            onInfo: () => showDialog(
                              context: context,
                              builder: (context) => ItemInfoDialog(item: item),
                            ),
                            onDelete: () => sideItemsCubit.removeItem(item.id!),
                            onNameEdit: () => sideItemsCubit.editItemNameDialog(
                              context: context,
                              controller: itemNameController,
                              item: item,
                            ),
                            onCommandEdit: () =>
                                sideItemsCubit.editItemOpenCommandDialog(
                              context: context,
                              item: item,
                            ),
                          ),
                        );
                      }

                      return Text('!');
                    },
                  ),
                );
              }
              return Expanded(
                child: GlobalLoading(
                  alignment: widget.isExpanded
                      ? Alignment.center
                      : Alignment.centerLeft,
                ),
              );
            },
            listener: (context, state) {
              if (state is SideItemsError) {
                //todo global snack bar
                debugPrint(state.message);
              }
            },
          ),
          // SideDivider(isExpanded: widget.isExpanded),

          //bottom
          FooterRow(
            isExpanded: widget.isExpanded,
            onPickUrlPressed: () async {
              widget.toggleShouldLoseFocus();

              SideUrl? url = await Picker.pickUrl(
                context: context,
                controller: urlController,
              );
              if (url != null) {
                sideItemsCubit.addItem(url);
              }
              widget.toggleShouldLoseFocus();
            },
            onPickFolderPressed: () async {
              widget.toggleShouldLoseFocus();

              SideFolder? folder = await Picker.pickFolder();
              if (folder != null) {
                sideItemsCubit.addItem(folder);
              }
              widget.toggleShouldLoseFocus();
            },
            onPickFilePressed: () async {
              widget.toggleShouldLoseFocus();

              SideFile? file = await Picker.pickFile();
              if (file != null) {
                sideItemsCubit.addItem(file);
              }
              widget.toggleShouldLoseFocus();
            },
          ),
        ],
      ),
    );
  }
}
