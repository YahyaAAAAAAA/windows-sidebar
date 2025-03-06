import 'package:flutter/material.dart';

class SideSmallButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final double? iconSize;
  final double? width;
  final double? height;
  final String? tooltip;
  final EdgeInsets? padding;

  const SideSmallButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize = 15,
    this.width = 20,
    this.height = 20,
    this.tooltip,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: IconButton(
        onPressed: onPressed,
        padding: padding,
        tooltip: tooltip,
        icon: Icon(
          icon,
          size: iconSize,
        ),
      ),
    );
  }
}
