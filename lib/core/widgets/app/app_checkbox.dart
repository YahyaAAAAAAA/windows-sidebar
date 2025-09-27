import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';

class AppCheckbox extends StatefulWidget {
  final bool? value;
  final ValueChanged<bool?>? onChanged;
  final MouseCursor? mouseCursor;
  final Color? activeColor;
  final Color? fillColor;
  final Color? checkColor;
  final Color? focusColor;
  final Color? hoverColor;
  final Radius? borderRadius;
  final Size? size;
  final FocusNode? focusNode;
  final double elevation;
  final double broderWidth;
  final bool autofocus;
  final bool isError;

  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.borderRadius,
    this.mouseCursor,
    this.activeColor,
    this.fillColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.focusNode,
    this.size = const Size(20, 20),
    this.elevation = 0,
    this.broderWidth = 1,
    this.autofocus = false,
    this.isError = false,
  });

  @override
  State<AppCheckbox> createState() => _AppCheckboxState();
}

class _AppCheckboxState extends State<AppCheckbox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    if (widget.value == true) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(AppCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value == true) {
        _controller.forward();
      } else if (widget.value == false) {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void handleChanged() {
    if (widget.onChanged == null) return;

    switch (widget.value) {
      case false:
        widget.onChanged!(true);
        break;
      case true:
        widget.onChanged!(false);
        break;
      case null:
        widget.onChanged!(false);
        break;
    }
  }

  MouseCursor getMouseCursor() {
    return widget.mouseCursor ??
        (widget.onChanged != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic);
  }

  Color getActiveColor(BuildContext context) {
    if (widget.isError) {
      return context.theme.colorScheme.error;
    }
    if (widget.activeColor != null) {
      return widget.activeColor!;
    }
    return context.theme.primaryColor;
  }

  Color getCheckColor(BuildContext context) {
    if (widget.checkColor != null) {
      return widget.checkColor!;
    }
    return context.theme.colorScheme.surface;
  }

  Color getInactiveColor(BuildContext context) {
    if (widget.isError) {
      return context.theme.colorScheme.error;
    }
    return context.theme.colorScheme.onSurface.withValues(alpha: 0.5);
  }

  Color getFillColor(BuildContext context) {
    //do not default to transparent so they could appear in skeletonizer (use Skeleton.leaf)
    return widget.fillColor ?? context.theme.scaffoldBackgroundColor;
  }

  Color getHoverColor(BuildContext context) {
    return widget.isError
        ? context.theme.colorScheme.error.withValues(alpha: 0.1)
        : context.theme.hoverColor;
  }

  BorderRadius get boderRadius => BorderRadius.all(
    widget.borderRadius ?? Radius.circular(kBorderRadius.outer),
  );

  Radius get radius =>
      widget.borderRadius ?? Radius.circular(kBorderRadius.outer);

  @override
  Widget build(BuildContext context) {
    return Skeleton.leaf(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: widget.size!.width,
          minHeight: widget.size!.height,
        ),
        child: Material(
          elevation: widget.elevation,
          color: getFillColor(context),
          borderRadius: boderRadius,
          child: InkWell(
            onTap: widget.onChanged != null ? handleChanged : null,
            borderRadius: boderRadius,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            hoverColor: getHoverColor(context),
            mouseCursor: getMouseCursor(),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: widget.size!,
                  painter: _AppCheckboxPainter(
                    value: widget.value,
                    activeColor: getActiveColor(context),
                    checkColor: getCheckColor(context),
                    inactiveColor: getInactiveColor(context),
                    fillColor:
                        Colors
                            .transparent, //if any other color it'll block the hover the color
                    animation: _animation.value,
                    enabled: widget.onChanged != null,
                    isError: widget.isError,
                    borderWidth: widget.broderWidth,
                    borderRadius: radius,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _AppCheckboxPainter extends CustomPainter {
  const _AppCheckboxPainter({
    required this.value,
    required this.activeColor,
    required this.checkColor,
    required this.inactiveColor,
    required this.fillColor,
    required this.animation,
    required this.enabled,
    required this.isError,
    required this.borderRadius,
    required this.borderWidth,
  });

  final bool? value;
  final Color activeColor;
  final Color fillColor;
  final Color checkColor;
  final Color inactiveColor;
  final double animation;
  final double borderWidth;
  final bool enabled;
  final bool isError;
  final Radius borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect roundedRect = RRect.fromRectAndRadius(rect, borderRadius);

    //colors based on state
    Color backgroundColor = fillColor;
    Color borderColor = inactiveColor;
    double borderWidth = this.borderWidth;

    if (!enabled) {
      borderColor = inactiveColor.withValues(alpha: 0.3);
    } else if (value == true) {
      backgroundColor = Color.lerp(Colors.transparent, activeColor, animation)!;
      borderColor = Color.lerp(inactiveColor, activeColor, animation)!;
      borderWidth = 1.5;
    } else if (value == null) {
      backgroundColor = Color.lerp(Colors.transparent, activeColor, animation)!;
      borderColor = Color.lerp(inactiveColor, activeColor, animation)!;
      borderWidth = 1.5;
    }

    //background
    if (backgroundColor != Colors.transparent) {
      paint.color = backgroundColor;
      canvas.drawRRect(roundedRect, paint);
    }

    //border
    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..color = borderColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect.deflate(borderWidth / 2), borderRadius),
      paint,
    );

    //checkmark or indeterminate mark
    if (animation > 0) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeCap = StrokeCap.round
        ..color = checkColor;

      if (isError) {
        //indeterminate state - horizontal line
        _drawIndeterminateMark(canvas, size, paint, animation);
      } else if (value == true) {
        //checkmark
        _drawCheckmark(canvas, size, paint, animation);
      }
    }
  }

  void _drawCheckmark(Canvas canvas, Size size, Paint paint, double progress) {
    final Path path = Path();

    final double centerX = size.width / 2;
    final double centerY = size.height / 1.7;
    final double checkSize = size.width * 0.55;

    //checkmark points
    final Offset start = Offset(
      centerX - checkSize * 0.4,
      centerY - checkSize * 0.1,
    );
    final Offset middle = Offset(
      centerX - checkSize * 0.1,
      centerY + checkSize * 0.2,
    );
    final Offset end = Offset(
      centerX + checkSize * 0.5,
      centerY - checkSize * 0.5,
    );

    final Offset currentEnd = Offset.lerp(middle, end, progress)!;
    path.moveTo(start.dx, start.dy);
    path.lineTo(middle.dx, middle.dy);
    path.lineTo(currentEnd.dx, currentEnd.dy);

    canvas.drawPath(path, paint);
  }

  void _drawIndeterminateMark(
    Canvas canvas,
    Size size,
    Paint paint,
    double progress,
  ) {
    final double centerY = size.height / 2;
    final double lineLength = size.width * 0.5 * progress;
    final double startX = (size.width - lineLength) / 2;
    final double endX = startX + lineLength;

    canvas.drawLine(Offset(startX, centerY), Offset(endX, centerY), paint);
  }

  @override
  bool shouldRepaint(_AppCheckboxPainter oldDelegate) {
    return value != oldDelegate.value ||
        activeColor != oldDelegate.activeColor ||
        checkColor != oldDelegate.checkColor ||
        inactiveColor != oldDelegate.inactiveColor ||
        animation != oldDelegate.animation ||
        enabled != oldDelegate.enabled ||
        isError != oldDelegate.isError;
  }
}
