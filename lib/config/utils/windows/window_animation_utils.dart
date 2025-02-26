import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowAnimationUtils {
  Future<Offset> getInitialPosition() async {
    final position = await windowManager.getPosition();
    return Offset(position.dx.toDouble(), position.dy.toDouble());
  }

  static Future<void> animateWindow(
    Offset targetOffset,
    AnimationController controller,
    Animation<Offset> animaiton,
  ) async {
    final currentPosition = await windowManager.getPosition();

    // Create the CurvedAnimation
    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut, // Apply your desired curve here
    );

    // Create the Tween animation
    animaiton = Tween<Offset>(
      begin:
          Offset(currentPosition.dx.toDouble(), currentPosition.dy.toDouble()),
      end: targetOffset,
    ).animate(curvedAnimation)
      ..addListener(() async {
        await windowManager.setPosition(animaiton.value);
      });

    // Start the animation
    controller.forward(from: 0);
  }
}
