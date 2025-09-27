import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/widgets/app/app_center.dart';

class AppContainer extends StatelessWidget with LogMixin {
  final Widget? child;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final List<BoxShadow>? boxShadow;
  final BoxBorder? boxBorder;
  final FocusNode? focusNode;
  final double? width;
  final double? height;
  final double? borderWidth;
  final void Function()? onTap;
  final void Function(PointerEnterEvent)? onMouseEnter;
  final void Function(PointerExitEvent)? onMouseExit;
  final void Function(PointerHoverEvent)? onMouseHover;
  final void Function(bool)? onFocusChange;
  final Duration? duration;
  final Curve? curve;
  final double elevation;
  final bool isAnimated;
  final bool isPanel;
  final bool isCentred;
  final bool canRequestFocus;

  const AppContainer({
    super.key,
    this.child,
    this.color,
    this.borderColor,
    this.padding,
    this.borderRadius,
    this.alignment,
    this.constraints,
    this.boxShadow,
    this.boxBorder,
    this.focusNode,
    this.height,
    this.width,
    this.borderWidth,
    this.onTap,
    this.onMouseEnter,
    this.onMouseExit,
    this.onMouseHover,
    this.onFocusChange,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.elevation = 0,
    this.isAnimated = false,
    this.isPanel = false,
    this.isCentred = false,
    this.canRequestFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isAnimated) {
      return buildAnimatedContainer(context);
    }
    return buildContainer(context);
  }

  BoxBorder getBorder(BuildContext context) {
    if (boxBorder != null) {
      return boxBorder!;
    } else if (borderWidth == 0) {
      return const Border.fromBorderSide(BorderSide.none);
    } else if (isPanel) {
      return Border(top: BorderSide(color: context.theme.dividerColor));
    }

    return Border.all(color: borderColor ?? context.theme.dividerColor, width: borderWidth ?? kBorderWidth.normal);
  }

  BorderRadiusGeometry getBorderRadius() {
    if (borderRadius != null) {
      return borderRadius!;
    } else if (isPanel) {
      return BorderRadius.only(
        bottomLeft: Radius.circular(kBorderRadius.outer),
        bottomRight: Radius.circular(kBorderRadius.outer),
      );
    }

    return BorderRadius.circular(kBorderRadius.outer);
  }

  Widget buildContainer(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: onFocusChange,
      child: MouseRegion(
        onEnter: onMouseEnter,
        onExit: onMouseExit,
        onHover: onMouseHover,
        child: AppCenter(
          enabled: isCentred,
          child: Container(
            width: width,
            height: height,
            constraints: constraints,
            padding: 0.pAll,
            alignment: alignment,
            decoration: BoxDecoration(
              color: color ?? context.theme.cardColor,
              border: getBorder(context),
              borderRadius: getBorderRadius(),
              boxShadow: boxShadow,
            ),
            child: Material(
              color: color ?? context.theme.cardColor,
              borderRadius: getBorderRadius(),
              elevation: elevation,
              child: InkWell(
                onTap: onTap,
                hoverColor: context.theme.hoverColor,
                splashColor: context.theme.splashColor,
                splashFactory: context.theme.splashFactory,
                overlayColor: WidgetStatePropertyAll(context.theme.splashColor),
                borderRadius: getBorderRadius().resolve(TextDirection.ltr),
                child: Padding(padding: padding ?? 0.pAll, child: child),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedContainer(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      canRequestFocus: canRequestFocus,
      onFocusChange: onFocusChange,
      child: MouseRegion(
        onEnter: onMouseEnter,
        onExit: onMouseExit,
        onHover: onMouseHover,
        child: AnimatedContainer(
          width: width,
          height: height,
          constraints: constraints,
          padding: 0.pAll,
          duration: duration!,
          curve: curve ?? Curves.easeInOut,
          alignment: alignment,
          decoration: BoxDecoration(
            color: color ?? context.theme.cardColor,
            border: getBorder(context),
            borderRadius: getBorderRadius(),
            boxShadow: boxShadow,
          ),
          child: Material(
            color: color ?? context.theme.cardColor,
            // color: Colors.transparent,
            borderRadius: getBorderRadius(),
            elevation: elevation,
            child: InkWell(
              onTap: onTap,
              hoverColor: context.theme.hoverColor,
              splashColor: context.theme.splashColor,
              splashFactory: context.theme.splashFactory,
              overlayColor: WidgetStatePropertyAll(context.theme.splashColor),
              borderRadius: getBorderRadius().resolve(TextDirection.ltr),
              child: Padding(padding: padding ?? 0.pAll, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
