import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  void push(
    Widget child, {
    Duration? duration,
  }) {
    Navigator.of(this).push(
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
}
