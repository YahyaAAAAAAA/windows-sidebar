import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
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
  }

  @override
  void dispose() {
    positionController?.dispose();
    sizeController?.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          MouseRegion(
            onEnter: (_) => animateTo(originalPosition + Offset(-50, 0)),
            onExit: (_) => animateTo(originalPosition),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.red),
                  elevation: WidgetStatePropertyAll(3),
                ),
                onPressed: () async {
                  animateSizeTo(Size(200, 400));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
