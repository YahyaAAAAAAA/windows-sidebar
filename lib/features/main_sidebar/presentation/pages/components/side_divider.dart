import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';

class SideDivider extends StatelessWidget {
  final bool isExpanded;
  final double? thickness;
  final double? height;
  final double? indent;
  final double? endIndent;

  const SideDivider({
    super.key,
    required this.isExpanded,
    this.thickness = 0.5,
    this.height = 10,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      //expanded divider
      firstChild: Divider(
        thickness: thickness,
        height: height,
        indent: indent,
        endIndent: endIndent,
      ),
      //shrunk divider
      secondChild: Divider(
        thickness: thickness,
        indent: kDividerIndent,
        endIndent: kDividerEndIndent,
        height: height,
      ),
      crossFadeState:
          isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
