import 'package:flutter/material.dart';

class OverflowTooltipText extends StatelessWidget {
  final String text;
  final double maxWidth;
  final TextStyle? style;
  final bool expandOnlyOverflowText;
  final bool disabled;

  const OverflowTooltipText({
    super.key,
    required this.text,
    required this.maxWidth,
    this.style,
    this.expandOnlyOverflowText = true,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style ?? const TextStyle()),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    final bool isOverflowing = textPainter.didExceedMaxLines;

    Widget textWidget = Text(
      text,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (disabled) {
      if (expandOnlyOverflowText) {
        return textWidget;
      } else {
        return Expanded(child: textWidget);
      }
    }

    if (isOverflowing) {
      return Expanded(child: Tooltip(message: text, child: textWidget));
    } else {
      if (expandOnlyOverflowText) {
        return textWidget;
      } else {
        return Expanded(child: textWidget);
      }
    }
  }
}
