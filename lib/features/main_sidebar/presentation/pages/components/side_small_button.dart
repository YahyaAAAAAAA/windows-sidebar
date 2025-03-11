import 'package:flutter/material.dart';

enum SideSmallButtonType {
  icon,
  text,
}

class SideSmallButton extends StatelessWidget {
  final void Function()? onPressed;
  final double? iconSize;
  final double? width;
  final double? height;
  final String? tooltip;
  final EdgeInsets? padding;
  final ButtonStyle? buttonStyle;

  final IconData? icon;
  const SideSmallButton.icon({
    super.key,
    required this.icon,
    this.onPressed,
    this.iconSize = 15,
    this.width = 20,
    this.height = 20,
    this.tooltip,
    this.buttonStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
  }) : text = null;

  final Text? text;
  const SideSmallButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.iconSize = 15,
    this.width = 20,
    this.height = 20,
    this.tooltip,
    this.buttonStyle,
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
  }) : icon = null;

  SideSmallButtonType decide() {
    if (icon != null) {
      return SideSmallButtonType.icon;
    } else {
      return SideSmallButtonType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: IconButton(
        onPressed: onPressed,
        padding: padding,
        tooltip: tooltip,
        style: buttonStyle,
        icon: decide() == SideSmallButtonType.icon
            ? Icon(
                icon,
                size: iconSize,
              )
            : text!,
      ),
    );
  }
}
