import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';

class SideSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;
  final String? label;

  const SideSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.min = 0.0,
    this.max = 100.0,
    this.divisions,
    this.label,
  });

  @override
  State<SideSlider> createState() => _SideSliderState();
}

class _SideSliderState extends State<SideSlider> {
  bool isHoverd = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) => setState(() => isHoverd = true),
      onExit: (event) => setState(() => isHoverd = false),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          thumbShape: CustomSliderThumbShape(context, isHoverd ? 8 : 6),
          // overlayShape: RectangularSliderValueIndicatorShape(),
          valueIndicatorShape: CustomValueIndicatorShape(context),
          overlayShape: SliderComponentShape.noOverlay,
          tickMarkShape: SliderTickMarkShape.noTickMark,
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
    );
  }
}

class CustomSliderThumbShape extends SliderComponentShape {
  final BuildContext context;
  final double? circleRadius;

  CustomSliderThumbShape(
    this.context,
    this.circleRadius,
  );

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

    //outer circle
    final Paint outerPaint = Paint()
      ..color = Theme.of(this.context).primaryColor.shade700
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 12, outerPaint);

    //inner circle
    final Paint innerPaint = Paint()
      ..color = Theme.of(this.context).sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, circleRadius ?? 6, innerPaint);
  }
}

class CustomValueIndicatorShape extends SliderComponentShape {
  final BuildContext context;

  CustomValueIndicatorShape(this.context);

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
    final Canvas canvas = context.canvas;
    const double width = 40;
    const double height = 30;
    final Rect rect = Rect.fromCenter(
      center: Offset(center.dx, center.dy - 35),
      width: width,
      height: height,
    );

    final Paint paint = Paint()
      ..color = Theme.of(this.context).primaryColor
      ..style = PaintingStyle.fill;

    final RRect rrect =
        RRect.fromRectAndRadius(rect, const Radius.circular(kOuterRadius));
    canvas.drawRRect(rrect, paint);

    // Draw the text inside the indicator
    labelPainter.layout();
    labelPainter.paint(
      canvas,
      Offset(center.dx - (labelPainter.width / 2), center.dy - 45),
    );
  }
}
