import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/transition_animation.dart';

extension BuildContextExtension on BuildContext {
  void push(
    Widget child, {
    Duration? duration,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transitionBuilder,
  }) {
    Navigator.of(this).push(
      PageRouteBuilder(
        transitionDuration: duration ?? Duration(milliseconds: 500),
        reverseTransitionDuration: duration ?? Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: transitionBuilder ?? TransitionAnimations.fade,
      ),
    );
  }

  void replace(
    Widget child, {
    Duration? duration,
  }) {
    Navigator.of(this).pushReplacement(
      PageRouteBuilder(
        transitionDuration: duration ?? Duration(milliseconds: 500),
        reverseTransitionDuration: duration ?? Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: 0.0, end: 1.0);
          final fadeAnimation = animation.drive(tween);
          return FadeTransition(
            opacity: fadeAnimation,
            child: child,
          );
        },
      ),
    );
  }

  void pop() {
    Navigator.of(this).pop();
  }

  // Show a basic SnackBar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: Text(
            message,
            style: TextStyle(
              color: GColors.windowColor.shade600,
            ),
          ),
        ),
        backgroundColor: GColors.windowColor.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kOuterRadius),
            topRight: Radius.circular(kOuterRadius),
          ),
        ),
        duration: duration ?? const Duration(seconds: 2),
      ),
    );
  }
}
