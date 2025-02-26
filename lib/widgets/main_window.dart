import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/utils/global_colors.dart';
import 'package:windows_widgets/utils/windows/window_utils.dart';

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
  String? folderPath;

  StreamSubscription? colorSubscription;

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

    colorSubscription = WindowUtils.watchAccentColor().listen((color) {
      setState(() => GColors.windowColor = color);
    });
  }

  @override
  void dispose() {
    positionController?.dispose();
    sizeController?.dispose();
    colorSubscription?.cancel();
    windowManager.removeListener(this);
    super.dispose();
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
        await WindowUtils.centerWindowOnY();
      });

    sizeController!.forward(from: 0);
  }

  String? _filePath;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    } else {
      // User canceled the picker
    }
  }

  void openFile() {
    if (folderPath != null) {
      Process.run('explorer', [folderPath!], runInShell: true);
    } else {
      // Show a message to the user that no file is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file selected')),
      );
    }
  }

  Future<void> pickFolder() async {
    // Open a folder picker dialog
    String? selectedFolder = await FilePicker.platform.getDirectoryPath();

    if (selectedFolder != null) {
      setState(() {
        folderPath = selectedFolder; // Save the selected folder path
      });
    } else {
      // User canceled the folder picker
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No folder selected')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => animateTo(originalPosition + Offset(-50, 0)),
      onExit: (_) => animateTo(originalPosition),
      child: Scaffold(
        backgroundColor: GColors.windowColor.withValues(alpha: 0.5),
        body: Column(
          children: [
            IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              ),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.red),
                elevation: WidgetStatePropertyAll(3),
              ),
              onPressed: () async => animateSizeTo(Size(200, 400)),
            ),
            IconButton(
              onPressed: pickFolder,
              icon: Icon(
                Icons.file_open_rounded,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: openFile,
              icon: Icon(
                Icons.file_copy_rounded,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
