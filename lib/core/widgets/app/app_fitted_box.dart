import 'package:flutter/material.dart';

class AppFittedBox extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final BoxFit fit;
  final Alignment alignment;
  final Clip clipBehavior;

  const AppFittedBox({
    super.key,
    required this.child,
    this.enabled = true,
    this.alignment = Alignment.center,
    this.fit = BoxFit.contain,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return FittedBox(
        alignment: alignment,
        fit: fit,
        clipBehavior: clipBehavior,
        child: child,
      );
    }
    return child;
  }
}
