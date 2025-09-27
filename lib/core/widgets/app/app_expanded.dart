import 'package:flutter/material.dart';

class AppExpanded extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final int flex;

  const AppExpanded({
    super.key,
    required this.child,
    this.enabled = true,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return Expanded(flex: flex, child: child);
    }
    return child;
  }
}
