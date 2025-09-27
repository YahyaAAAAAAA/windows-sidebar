import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';

//styled for windows 11
class AppRadio<T> extends StatefulWidget {
  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final MouseCursor? mouseCursor;
  final bool toggleable;
  final Color? activeColor;
  final WidgetStateProperty<Color?>? fillColor;
  final Color? focusColor;
  final Color? hoverColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final double? splashRadius;
  final MaterialTapTargetSize? materialTapTargetSize;
  final VisualDensity? visualDensity;
  final FocusNode? focusNode;
  final bool autofocus;
  final double? width;
  final double? height;

  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.width = 15,
    this.height = 15,
    this.mouseCursor,
    this.toggleable = false,
    this.activeColor,
    this.fillColor,
    this.focusColor,
    this.hoverColor,
    this.overlayColor,
    this.splashRadius,
    this.materialTapTargetSize,
    this.visualDensity,
    this.focusNode,
    this.autofocus = false,
  });

  bool get _selected => value == groupValue;

  @override
  State<AppRadio<T>> createState() => _AppRadioState<T>();
}

class _AppRadioState<T> extends State<AppRadio<T>>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController hoverController;
  late Animation<double> animation;
  late Animation<double> hoverAnimation;

  bool isHovering = false;
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    hoverController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    hoverAnimation = CurvedAnimation(
      parent: hoverController,
      curve: Curves.easeInOut,
    );

    if (widget._selected) {
      controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AppRadio<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._selected != oldWidget._selected) {
      if (widget._selected) {
        controller.forward();
      } else {
        controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    hoverController.dispose();
    super.dispose();
  }

  void handleChanged(bool? selected) {
    if (selected == null) {
      widget.onChanged!(null);
      return;
    }
    if (selected) {
      widget.onChanged!(widget.value);
    }
  }

  void handleHover(bool hovering) {
    if (hovering != isHovering) {
      setState(() {
        isHovering = hovering;
      });
      if (hovering) {
        hoverController.forward();
      } else {
        hoverController.reverse();
      }
    }
  }

  void handleFocusChange(bool focused) {
    setState(() {
      isFocused = focused;
    });
  }

  Color getActiveColor(BuildContext context) {
    if (widget.activeColor != null) {
      return widget.activeColor!;
    }
    return context.theme.primaryColor;
  }

  Color getInactiveColor(BuildContext context) {
    return context.theme.colorScheme.onSurface.withValues(alpha: 0.54);
  }

  @override
  Widget build(BuildContext context) {
    final VisualDensity effectiveVisualDensity =
        widget.visualDensity ?? Theme.of(context).visualDensity;
    final Size size = Size(
      20.0 + effectiveVisualDensity.horizontal * 2.0,
      20.0 + effectiveVisualDensity.vertical * 2.0,
    );

    final MaterialTapTargetSize effectiveMaterialTapTargetSize =
        widget.materialTapTargetSize ?? Theme.of(context).materialTapTargetSize;
    final Size minSize =
        effectiveMaterialTapTargetSize == MaterialTapTargetSize.shrinkWrap
            ? Size.zero
            : const Size(48.0, 48.0);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Focus(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        onFocusChange: handleFocusChange,
        child: MouseRegion(
          onEnter: (_) => handleHover(true),
          onExit: (_) => handleHover(false),
          cursor:
              widget.mouseCursor ??
              (widget.onChanged != null
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic),
          child: GestureDetector(
            onTap:
                widget.onChanged != null
                    ? () {
                      if (widget.toggleable && widget._selected) {
                        handleChanged(false);
                        return;
                      }
                      if (!widget._selected) {
                        handleChanged(true);
                      }
                    }
                    : null,
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(100),
              ),
              constraints: BoxConstraints.tightFor(
                width: minSize.width,
                height: minSize.height,
              ),
              child: AnimatedBuilder(
                animation: Listenable.merge([animation, hoverAnimation]),
                builder: (context, child) {
                  return CustomPaint(
                    size: size,
                    painter: AppRadioPainter(
                      selected: widget._selected,
                      activeColor: getActiveColor(context),
                      inactiveColor: getInactiveColor(context),
                      hoverColor: widget.hoverColor ?? context.theme.hoverColor,
                      focusColor: widget.focusColor ?? context.theme.focusColor,
                      animation: animation.value,
                      hoverAnimation: hoverAnimation.value,
                      hovering: isHovering,
                      focused: isFocused,
                      enabled: widget.onChanged != null,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AppRadioPainter extends CustomPainter {
  const AppRadioPainter({
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.hoverColor,
    required this.focusColor,
    required this.animation,
    required this.hoverAnimation,
    required this.hovering,
    required this.focused,
    required this.enabled,
  });

  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final Color hoverColor;
  final Color focusColor;
  final double animation;
  final double hoverAnimation;
  final bool hovering;
  final bool focused;
  final bool enabled;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    //background circle
    Color backgroundColor = Colors.transparent;
    Color borderColor = inactiveColor;
    double borderWidth = 1.0;

    if (!enabled) {
      borderColor = inactiveColor.withValues(alpha: 0.3);
    } else if (selected) {
      backgroundColor = Color.lerp(Colors.transparent, activeColor, animation)!;
      borderColor = Color.lerp(inactiveColor, activeColor, animation)!;
      borderWidth = 1.5;
    } else if (hovering) {
      backgroundColor =
          Color.lerp(
            Colors.transparent,
            hoverColor.withValues(alpha: 0.08),
            hoverAnimation,
          )!;
      borderColor =
          Color.lerp(
            inactiveColor,
            activeColor.withValues(alpha: 0.7),
            hoverAnimation,
          )!;
    }

    //focus ring
    if (focused && enabled) {
      paint.color = focusColor.withValues(alpha: 0.12);
      canvas.drawCircle(center, radius + 2, paint);
    }

    //background
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawCircle(center, radius - borderWidth, paint);
    }

    //border
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;
    canvas.drawCircle(center, radius - borderWidth / 2, paint);

    //inner dot
    if (selected && animation > 0) {
      paint.style = PaintingStyle.fill;
      paint.color = Colors.white;

      //animate the inner dot size
      double dotRadius = (radius) * 0.5 * animation;

      //add a subtle scale effect during animation
      if (animation < 1.0) {
        dotRadius *= (0.8 + 0.2 * Curves.elasticOut.transform(animation));
      }

      canvas.drawCircle(center, dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(AppRadioPainter oldDelegate) {
    return selected != oldDelegate.selected ||
        activeColor != oldDelegate.activeColor ||
        inactiveColor != oldDelegate.inactiveColor ||
        animation != oldDelegate.animation ||
        hoverAnimation != oldDelegate.hoverAnimation ||
        hovering != oldDelegate.hovering ||
        focused != oldDelegate.focused ||
        enabled != oldDelegate.enabled;
  }
}
