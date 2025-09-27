import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/nullable_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_button.dart';

//no background with border
class BorderButton extends AppButton {
  final ButtonStyle? buttonStyle;
  final double? borderWidth;

  const BorderButton({
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
    this.buttonStyle,
    this.borderWidth = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = ButtonStyle(
      backgroundColor: const WidgetStatePropertyAll(Colors.transparent),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius.outer),
          side: BorderSide(
            color: context.theme.dividerColor,
            width: borderWidth!,
          ),
        ),
      ),
    );

    return AppButton(
      onPressed: onPressed,
      width: width,
      height: height,
      alignment: alignment,
      borderRadius: borderRadius,
      constraints: constraints,
      curve: curve,
      duration: duration,
      isAnimated: isAnimated,
      padding: padding,
      onMouseEnter: onMouseEnter,
      onMouseHover: onMouseHover,
      onMouseExit: onMouseExit,
      tooltip: tooltip,
      style:
          style.isNull
              ? borderStyle.merge(style)
              : buttonStyle?.merge(borderStyle.merge(style)),
      child: child,
    );
  }
}
