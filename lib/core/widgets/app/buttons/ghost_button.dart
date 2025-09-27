import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/nullable_extensions.dart';
import 'package:windows_widgets/core/widgets/app/app_button.dart';

//no background no hover effect
class GhostButton extends AppButton {
  final ButtonStyle? buttonStyle;

  const GhostButton({
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
    super.hoverColor = Colors.transparent,
    this.buttonStyle,
  });

  @override
  Widget build(BuildContext context) {
    final ghostStyle = ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.hovered)) {
          return hoverColor;
        }
        return null;
      }),
    );

    return AppButton(
      onPressed: onPressed,
      width: width,
      height: height,
      isAnimated: isAnimated,
      constraints: constraints,
      duration: duration,
      alignment: alignment,
      padding: padding,
      tooltip: tooltip,
      borderRadius: borderRadius,
      curve: curve,
      hoverColor: hoverColor,
      onMouseEnter: onMouseEnter,
      onMouseExit: onMouseExit,
      onMouseHover: onMouseHover,
      style:
          style.isNull
              ? ghostStyle.merge(style)
              : buttonStyle?.merge(ghostStyle.merge(style)),
      child: child,
    );
  }
}
