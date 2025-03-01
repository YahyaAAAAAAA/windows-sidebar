import 'dart:async';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/config/utils/right_click_menu.dart';
import 'package:windows_widgets/config/utils/smooth_listview.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/database/database_helper.dart';
import 'package:windows_widgets/models/side_file.dart';
import 'package:windows_widgets/models/side_folder.dart';
import 'package:windows_widgets/models/side_item.dart';
import 'package:windows_widgets/widgets/components/header_row.dart';
import 'package:windows_widgets/widgets/components/side_button.dart';
import 'package:windows_widgets/widgets/components/side_divider.dart';
import 'package:windows_widgets/widgets/components/side_item_card.dart';

class MainWindow extends StatefulWidget {
  final bool isExpanded;
  final VoidCallback toggleExpanded;

  const MainWindow({
    super.key,
    required this.isExpanded,
    required this.toggleExpanded,
  });

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow>
    with TickerProviderStateMixin, WindowListener, WindowAnimationUtilsMixin {
  List<SideItem> sideItems = [];
  IconData folderIcon = Custom.folder;

  @override
  void initState() {
    super.initState();

    _loadSideItems();

    // WindowUtils.transparent();
  }

  Future<void> _loadSideItems() async {
    final items = await DatabaseHelper.getSideItems();
    setState(() {
      sideItems = items;
    });
  }

  Future<void> _addFile(SideFile file) async {
    await DatabaseHelper.insertSideItem(file);
    _loadSideItems();
  }

  Future<void> _addFolder(SideFolder folder) async {
    await DatabaseHelper.insertSideItem(folder);
    _loadSideItems();
  }

  Future<void> _deleteItem(int id) async {
    await DatabaseHelper.deleteSideItem(id);
    _loadSideItems();
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
          backgroundColor: GColors.windowColor,
          body: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //logo & settings
                HeaderRow(
                  expandIcon: widget.isExpanded
                      ? Icons.arrow_back_ios_new_outlined
                      : Icons.arrow_forward_ios_rounded,
                  onExpandPressed: () {
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
                Expanded(
                  child: SmoothListView(
                    itemCount: sideItems.length,
                    separatorBuilder: (context, index) => SizedBox(height: 5),
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final item = sideItems[index];
                      if (item is SideFolder) {
                        return SideItemCard.folder(
                          folder: item,
                          icon: folderIcon,
                          onEnter: (_) => setState(
                              () => item.icon = Custom.folder_open_fill),
                          onExit: (_) =>
                              setState(() => item.icon = Custom.folder_fill),
                          onRightClick: (context, position) async {
                            await showContextMenu(
                              context,
                              position,
                              onDelete: () => _deleteItem(item.id!),
                            );
                          },
                        );
                      }
                      if (item is SideFile) {
                        return SideItemCard.file(
                          file: item,
                          onRightClick: (context, position) async {
                            await showContextMenu(
                              context,
                              position,
                              onDelete: () => _deleteItem(item.id!),
                            );
                          },
                        );
                      }

                      return Text('!');
                    },
                  ),
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
                          _addFolder(folder);

                          setState(() {});
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
                      _addFile(file);

                      setState(() {});
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
