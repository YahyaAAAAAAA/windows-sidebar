import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/nullable_extensions.dart';
import 'package:windows_widgets/core/widgets/app/app_button.dart';

//normal icon button background
class SecondaryButton extends AppButton {
  final ButtonStyle? buttonStyle;

  const SecondaryButton({
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
    final primaryStyle = ButtonStyle(
      backgroundColor: WidgetStatePropertyAll(
        context.theme.iconButtonTheme.style?.backgroundColor?.resolve({}),
      ),
    );

    return AppButton(
      onPressed: onPressed,
      height: height,
      width: width,
      isAnimated: isAnimated,
      padding: padding,
      alignment: alignment,
      constraints: constraints,
      curve: curve,
      duration: duration,
      tooltip: tooltip,
      borderRadius: borderRadius,
      onMouseEnter: onMouseEnter,
      onMouseExit: onMouseExit,
      onMouseHover: onMouseHover,
      hoverColor: hoverColor,
      style:
          buttonStyle.isNull
              ? primaryStyle.merge(style)
              : buttonStyle?.merge(primaryStyle.merge(style)),
      child: child,
    );
  }
}
