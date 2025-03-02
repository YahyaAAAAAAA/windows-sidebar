import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';

mixin WindowAnimationUtilsMixin<T extends StatefulWidget>
    on TickerProviderStateMixin<T>, WindowListener {
  AnimationController? positionController;
  AnimationController? sizeController;
  Animation<Offset>? positionAnimation;
  Animation<Size>? sizeAnimation;
  CurvedAnimation? curvedAnimation;

  @override
  void initState() {
    super.initState();

    windowManager.addListener(this);

    positionController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    sizeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    positionController?.dispose();
    sizeController?.dispose();
    super.dispose();
  }

  Future<void> animatePositionTo(Offset targetOffset) async {
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

  Future<void> animateAlignmentTo(Alignment targetAlignment) async {
    final screenSize = (await screenRetriever.getPrimaryDisplay()).size;
    final windowSize = await windowManager.getSize();
    final currentPosition = await windowManager.getPosition();
    // final width = windowSize.width;

    var targetOffset = Offset(
      (screenSize.width - windowSize.width) * (targetAlignment.x + 1) / 2,
      (screenSize.height - windowSize.height) * (targetAlignment.y + 1) / 2,
    );

    //extra offset
    // targetOffset = Offset(targetOffset.dx + width - 1, targetOffset.dy);

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
}
