import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';

class AppButton extends StatelessWidget with LogMixin {
  final Widget child;
  final bool isAnimated;
  final Duration? duration;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final ButtonStyle? style;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final String? tooltip;
  final Color? hoverColor;
  final Curve? curve;
  final BorderRadiusGeometry? borderRadius;
  final void Function(PointerEnterEvent)? onMouseEnter;
  final void Function(PointerExitEvent)? onMouseExit;
  final void Function(PointerHoverEvent)? onMouseHover;

  const AppButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.style,
    this.constraints,
    this.duration,
    this.isAnimated = false,
    this.alignment,
    this.padding,
    this.tooltip,
    this.hoverColor,
    this.curve,
    this.borderRadius,
    this.onMouseEnter,
    this.onMouseExit,
    this.onMouseHover,
  });

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      width: width,
      height: height,
      curve: curve,
      borderRadius: borderRadius ?? BorderRadius.circular(kBorderRadius.outer),
      isAnimated: isAnimated,
      constraints: constraints,
      duration: duration,
      alignment: alignment,
      onMouseEnter: onMouseEnter,
      onMouseExit: onMouseExit,
      onMouseHover: onMouseHover,
      elevation: kElevation.none,
      color: Colors.transparent,
      borderWidth: 0,
      boxShadow: List.empty(),
      child: buildButton(),
    );
  }

  IconButton buildButton() => IconButton(
    onPressed: onPressed,
    icon: child,
    padding: padding ?? 0.pAll,
    style: style,
    tooltip: tooltip,
    hoverColor: hoverColor,
  );
}
