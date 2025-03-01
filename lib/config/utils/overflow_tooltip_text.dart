import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

class OverflowTooltipText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const OverflowTooltipText({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style ?? const TextStyle()),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: kMaxTextWidth);

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
              // verticalOffset: -40,
              waitDuration: Duration(milliseconds: 300),
              exitDuration: Duration.zero,
              decoration: BoxDecoration(
                color: GColors.windowColor.shade600,
                borderRadius: BorderRadius.circular(kOuterRadius),
              ),
              textStyle: TextStyle(
                color: GColors.windowColor.shade100,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
              child: textWidget,
            ),
          )
        : textWidget;
  }
}
