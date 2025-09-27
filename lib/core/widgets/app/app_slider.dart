import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_fitted_box.dart';
import 'package:windows_widgets/core/widgets/skeleton_container.dart';

class AppSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final double scale;
  final double activeThumbSize;
  final double inactiveThumbSize;
  final double thumbRingSize;
  final Curve curve;
  final ValueChanged<double>? onChanged;
  final Duration duration;
  final int? divisions;
  final String? label;
  final Color? thumbColor;
  final Color? thumbRingColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? labelBackgroundColor;
  final Color? shadowColor;
  final double? labelBorderRadius;
  final Size? labelSize;
  final TextStyle? labelTextStyle;
  final BoxFit? fit;
  final double? width;
  final double? height;

  const AppSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.scale = 1,
    this.divisions,
    this.label,
    this.duration = const Duration(milliseconds: 150),
    this.curve = Curves.easeInOut,
    this.inactiveThumbSize = 6,
    this.activeThumbSize = 8,
    this.thumbRingSize = 12,
    this.thumbColor,
    this.thumbRingColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.labelBackgroundColor,
    this.shadowColor,
    this.labelBorderRadius,
    this.labelSize,
    this.labelTextStyle,
    this.fit,
    this.height,
    this.width,
  });

  @override
  State<AppSlider> createState() => _AppSliderState();
}

class _AppSliderState extends State<AppSlider> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _animation = Tween<double>(
      begin: widget.inactiveThumbSize,
      end: widget.activeThumbSize,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Skeleton.replace(
      replacement: const SkeletonContainer(),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: AppFittedBox(
          fit: widget.fit ?? BoxFit.none,
          child: Transform.scale(
            scale: widget.scale,
            child: MouseRegion(
              onEnter: (_) => _controller.forward(),
              onExit: (_) => _controller.reverse(),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: CustomSliderThumbShape(
                      context,
                      thumbSize: _animation.value,
                      shadowColor: widget.shadowColor ?? context.theme.shadowColor,
                      thumbColor:
                          widget.thumbColor ??
                          (widget.onChanged != null ? context.primaryColor : context.theme.disabledColor),
                      thumbRingColor: widget.thumbRingColor ?? context.theme.cardColor,
                      thumbRingSize: widget.thumbRingSize,
                    ),
                    valueIndicatorShape: CustomValueIndicatorShape(
                      context,
                      labelBorderRadius: widget.labelBorderRadius ?? kBorderRadius.outer,
                      labelBackgroundColor: widget.labelBackgroundColor ?? context.theme.cardColor,
                      labelSize: widget.labelSize ?? const Size(40, 40),
                      shadowColor: widget.shadowColor ?? context.theme.shadowColor.withValues(alpha: 0.1),
                    ),
                    overlayShape: SliderComponentShape.noOverlay,
                    tickMarkShape: SliderTickMarkShape.noTickMark,
                    activeTrackColor: widget.activeTrackColor ?? context.primaryColor,
                    inactiveTrackColor: widget.inactiveTrackColor ?? context.theme.disabledColor,
                    showValueIndicator: ShowValueIndicator.onDrag,
                  ),
                  child: Slider(
                    value: widget.value,
                    min: widget.min,
                    max: widget.max,
                    label: widget.label,
                    divisions: widget.divisions,
                    onChanged: widget.onChanged,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final BuildContext context;
  final double thumbSize;
  final double thumbRingSize;
  final Color thumbColor;
  final Color thumbRingColor;
  final Color shadowColor;

  CustomSliderThumbShape(
    this.context, {
    required this.thumbSize,
    required this.thumbRingSize,
    required this.thumbColor,
    required this.thumbRingColor,
    required this.shadowColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(24, 24);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final shadow = Paint()
      ..color = shadowColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.2);
    canvas.drawCircle(center, thumbRingSize, shadow);

    //outer circle
    final Paint outerPaint = Paint()
      ..color = thumbRingColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbRingSize, outerPaint);

    //inner circle
    final Paint innerPaint = Paint()
      ..color = thumbColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, thumbSize, innerPaint);
  }
}

class CustomValueIndicatorShape extends SliderComponentShape {
  final BuildContext context;
  final Color labelBackgroundColor;
  final Color shadowColor;
  final double labelBorderRadius;
  final Size labelSize;
  final TextStyle? labelTextStyle;

  CustomValueIndicatorShape(
    this.context, {
    required this.labelBackgroundColor,
    required this.labelBorderRadius,
    required this.labelSize,
    required this.shadowColor,
    this.labelTextStyle,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => const Size(40, 30);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    //check if indicator should be visible based on activation animation
    if (activationAnimation.value == 0.0) return;

    final Canvas canvas = context.canvas;
    double width = labelSize.width;
    double height = labelSize.height;

    //apply activation animation to opacity and scale
    final double opacity = activationAnimation.value;
    final double scale = activationAnimation.value;

    final Rect rect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 45),
      width: width * scale,
      height: height * scale,
    );

    final Paint paint = Paint()
      ..color = labelBackgroundColor.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final RRect rrect = RRect.fromRectAndRadius(rect, Radius.circular(labelBorderRadius));

    final shadow = Paint()
      ..color = shadowColor.withValues(alpha: opacity * 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawRRect(rrect.shift(const Offset(0, 2)), shadow);

    canvas.drawRRect(rrect, paint);

    //draw the text inside the indicator with opacity
    final textStyle =
        labelTextStyle ??
        this.context.theme.textTheme.titleLarge?.copyWith(
          fontSize: this.context.theme.textTheme.titleLarge!.fontSize! - 2,
          color: this.context.theme.textTheme.titleLarge?.color?.withValues(alpha: opacity),
        );

    labelPainter.text = TextSpan(text: labelPainter.text?.toPlainText(), style: textStyle);

    labelPainter.layout();

    //apply scale to text position as well
    final textOffset = Offset(
      center.dx - (labelPainter.width / 2),
      center.dy - 60 + (5 * (1 - scale)), //slight offset animation
    );

    labelPainter.paint(canvas, textOffset);
  }
}
