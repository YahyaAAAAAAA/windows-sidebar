import 'package:flutter/material.dart';

class AppCenter extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const AppCenter({super.key, required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return Center(child: child);
    }
    return child;
  }
}
