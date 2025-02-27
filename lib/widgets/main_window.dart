import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/config/utils/right_click_menu.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/database_helper.dart';
import 'package:windows_widgets/models/side_file.dart';
import 'package:windows_widgets/models/side_folder.dart';
import 'package:windows_widgets/models/side_item.dart';
import 'package:windows_widgets/widgets/side_button.dart';
import 'package:windows_widgets/widgets/side_file_card.dart';
import 'package:windows_widgets/widgets/side_folder_card.dart';

class MainWindow extends StatefulWidget {
  const MainWindow({
    super.key,
  });

  @override
  State<MainWindow> createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow>
    with TickerProviderStateMixin, WindowListener {
  AnimationController? positionController;
  AnimationController? sizeController;
  Animation<Offset>? positionAnimation;
  Animation<Size>? sizeAnimation;
  CurvedAnimation? curvedAnimation;
  Offset originalPosition = Offset.zero;
  Size originalSize = Size.zero;
  int focusHandle = 0;

  List<SideItem> sideItems = [];

  bool isOpen = false;

  @override
  void initState() {
    super.initState();

    positionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    sizeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    windowManager.addListener(this);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final position = await windowManager.getPosition();
        final size = await windowManager.getSize();

        setState(() {
          originalPosition =
              Offset(position.dx.toDouble(), position.dy.toDouble());
          originalSize = Size(size.width.toDouble(), size.height.toDouble());
        });
      },
    );

    _loadSideItems();
    // WindowUtils.transparent();
  }

  @override
  void dispose() {
    positionController?.dispose();
    sizeController?.dispose();
    windowManager.removeListener(this);
    super.dispose();
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

  Future<void> _deleteItem(String path) async {
    await DatabaseHelper.deleteSideItem(path);
    _loadSideItems();
  }

  Future<void> animateTo(Offset targetOffset) async {
    final currentPosition = await windowManager.getPosition();

    curvedAnimation = CurvedAnimation(
      parent: positionController!,
      curve: Curves.easeInOut,
    );

    positionAnimation = Tween<Offset>(
      begin:
          Offset(currentPosition.dx.toDouble(), currentPosition.dy.toDouble()),
      end: targetOffset,
    ).animate(curvedAnimation!)
      ..addListener(() async {
        await windowManager.setPosition(positionAnimation!.value);
      });

    positionController!.forward(from: 0);
  }

  Future<void> animateSizeTo(Size targetSize) async {
    final currentSize = await windowManager.getSize();

    curvedAnimation = CurvedAnimation(
      parent: sizeController!,
      curve: Curves.easeInOut,
    );

    sizeAnimation = Tween<Size>(
      begin: Size(currentSize.width.toDouble(), currentSize.height.toDouble()),
      end: targetSize,
    ).animate(curvedAnimation!)
      ..addListener(() async {
        await windowManager.setSize(sizeAnimation!.value);
        await WindowUtils.centerOnY();
      });

    sizeController!.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) async {
        //todo save handle
        // focusHandle = await WindowUtils.getCurrentWindowHandle();

        //animate
        animateTo(WindowUtils.originalPosition + Offset(kOnEnterRight, 0));
      },
      onExit: (_) {
        //todo gave focus to previous window
        // WindowUtils.focusPreviousWindow(focusHandle);
        if (isOpen) {
          return;
        }
        //animate
        animateTo(WindowUtils.originalPosition);
      },
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kOutterRadius),
          child: Scaffold(
            backgroundColor: GColors.windowColor,
            body: Padding(
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onSecondaryTap: () async {
                      setState(() {
                        isOpen = true;
                      });
                      await showContextMenu(context, Offset(-60, 30));

                      setState(() {
                        isOpen = false;
                        print('ddd');
                        animateTo(WindowUtils.originalPosition);
                      });
                    },
                    child: SideButton(
                      icon: Icons.face_2_outlined,
                    ),
                  ),

                  Divider(
                    color: GColors.windowColor.shade100,
                    endIndent: 145,
                  ),

                  Expanded(
                    child: ListView.separated(
                      // shrinkWrap: true,
                      itemCount: sideItems.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final item = sideItems[index];
                        if (item is SideFolder) {
                          return SideFolderCard(folder: item);
                        }
                        if (item is SideFile) {
                          return SideFileCard(file: item);
                        }

                        return Text('!');
                      },
                    ),
                  ),
                  //bottom
                  // Spacer(),

                  Divider(
                    color: GColors.windowColor.shade100,
                    endIndent: 145,
                  ),

                  Row(
                    children: [
                      SideButton(
                        icon: Icons.drive_folder_upload,
                        onPressed: () async {
                          SideFolder? folder = await Picker.pickFolder();
                          if (folder != null) {
                            _addFolder(folder);

                            setState(() {});
                          }
                        },
                      ),
                      SizedBox(width: 10),
                      SideButton(
                        icon: Icons.file_upload_outlined,
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
                  SideButton(
                    icon: Icons.file_upload_outlined,
                    onPressed: () async {
                      _deleteItem(sideItems.first.path);

                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
