import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/nullable_extensions.dart';
import 'package:windows_widgets/core/widgets/app/app_button.dart';

//no background with hover effect
class SubtleButton extends AppButton {
  final ButtonStyle? buttonStyle;

  const SubtleButton({
    super.key,
    required super.child,
    super.onPressed,
    super.height,
    super.width,
    super.isAnimated,
    super.constraints,
    super.duration,
    super.alignment,
    super.padding,
    super.tooltip,
    super.borderRadius,
    super.curve,
    super.onMouseEnter,
    super.onMouseExit,
    super.onMouseHover,
    super.hoverColor,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    const borderStyle = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
    );
    return AppButton(
      onPressed: onPressed,
      width: width,
      height: height,
      isAnimated: isAnimated,
      constraints: constraints,
      duration: duration,
      curve: curve,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip,
      borderRadius: borderRadius,
      onMouseEnter: onMouseEnter,
      onMouseExit: onMouseExit,
      onMouseHover: onMouseHover,
      hoverColor: hoverColor,
      style:
          style.isNull
              ? borderStyle.merge(style)
              : buttonStyle?.merge(borderStyle.merge(style)),
      child: child,
    );
  }
}
