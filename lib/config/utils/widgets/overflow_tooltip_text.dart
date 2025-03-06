import 'package:flutter/material.dart';

class OverflowTooltipText extends StatelessWidget {
  final String text;
  final double maxWidth;
  final TextStyle? style;

  const OverflowTooltipText({
    super.key,
    required this.text,
    required this.maxWidth,
    this.style,
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

    return isOverflowing
        ? Expanded(
            child: Tooltip(
              message: text,
              child: textWidget,
            ),
          )
        : textWidget;
  }
}
