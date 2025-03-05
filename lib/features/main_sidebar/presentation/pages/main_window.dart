import 'package:animated_reorderable_list/animated_reorderable_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/config/utils/fade_effect.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/config/utils/transition_animation.dart';
import 'package:windows_widgets/config/utils/widgets/right_click_menu.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_cubit.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_states.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/header_row.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/no_items_row.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_button.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_item_card.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/settings_window.dart';

class MainWindow extends StatefulWidget {
  final bool isExpanded;
  final bool isPinned;
  final VoidCallback toggleExpanded;
  final VoidCallback togglePin;

  const MainWindow({
    super.key,
    required this.isExpanded,
    required this.isPinned,
    required this.toggleExpanded,
    required this.togglePin,
  });

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow>
    with TickerProviderStateMixin, WindowListener, WindowAnimationUtilsMixin {
  late final SideItemsCubit sideItemsCubit;
  IconData folderIcon = Custom.folder_fill;
  bool canDrag = false;

  @override
  void initState() {
    super.initState();

    //cubits
    sideItemsCubit = context.read<SideItemsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      //switch to 2 to hide completely
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kOuterRadius),
          bottomLeft: Radius.circular(kOuterRadius),
        ),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
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
                  onSettingsPressed: () => context.push(SettingsWindow(),
                      transitionBuilder: TransitionAnimations.slideFromRight),
                  onExpandPressed: () async {
                    widget.toggleExpanded();

                    if (!widget.isExpanded) {
                      animatePositionTo(WindowUtils.originalPosition +
                          Offset(kOnEnterRightExpand, 0));
                    } else {
                      animatePositionTo(WindowUtils.originalPosition +
                          Offset(kOnEnterRight, 0));
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
                        child: FadeEffect(
                          child: AnimatedReorderableListView(
                            items: items,
                            isSameItem: (a, b) => a.id == b.id,
                            enterTransition: [SlideInDown()],
                            exitTransition: [SlideInUp()],
                            insertDuration: const Duration(milliseconds: 300),
                            removeDuration: const Duration(milliseconds: 300),
                            dragStartDelay: const Duration(milliseconds: 300),
                            buildDefaultDragHandles: canDrag,
                            onReorder: (int oldIndex, int newIndex) =>
                                sideItemsCubit.onReorder(oldIndex, newIndex),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              if (item is SideFolder) {
                                return SideItemCard.folder(
                                  key: ValueKey(item.id),
                                  index: index,
                                  folder: item,
                                  icon: folderIcon,
                                  onEnter: (_) => setState(() =>
                                      item.icon = Custom.folder_open_fill),
                                  onExit: (_) => setState(
                                      () => item.icon = Custom.folder_fill),
                                  onRightClick: (context, position) async {
                                    await showContextMenu(
                                      context,
                                      position,
                                      widget.isExpanded,
                                      onDelete: () =>
                                          sideItemsCubit.removeItem(item.id!),
                                    );
                                  },
                                );
                              }
                              if (item is SideFile) {
                                return SideItemCard.file(
                                  key: ValueKey(item.id),
                                  index: index,
                                  file: item,
                                  onRightClick: (context, position) async {
                                    await showContextMenu(
                                      context,
                                      position,
                                      widget.isExpanded,
                                      onDelete: () =>
                                          sideItemsCubit.removeItem(item.id!),
                                    );
                                  },
                                );
                              }

                              return Text('!');
                            },
                          ),
                        ),
                      );
                    }
                    //todo global loading
                    return Expanded(
                      child: Align(
                        alignment: widget.isExpanded
                            ? Alignment.center
                            : Alignment.centerLeft,
                        child: CircularProgressIndicator(
                          color: GColors.windowColor.shade100,
                        ),
                      ),
                    );
                  },
                  listener: (context, state) {
                    if (state is SideItemsError) {
                      //todo global snack bar
                      print(state.message);
                    }
                  },
                ),

                SideDivider(isExpanded: widget.isExpanded),

                //bottom
                Row(
                  children: [
                    SideButton(
                      icon: Custom.add_folder_fill,
                      text: 'Pick a Folder',
                      onPressed: () async {
                        SideFolder? folder = await Picker.pickFolder();
                        if (folder != null) {
                          sideItemsCubit.addItem(folder);
                        }
                      },
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                SizedBox(height: 10),
                SideButton(
                  icon: Custom.add_document_fill,
                  text: 'Pick a File',
                  onPressed: () async {
                    SideFile? file = await Picker.pickFile();
                    if (file != null) {
                      sideItemsCubit.addItem(file);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
