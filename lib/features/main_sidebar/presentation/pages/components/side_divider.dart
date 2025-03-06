import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';

class SideDivider extends StatelessWidget {
  final bool isExpanded;

  const SideDivider({
    super.key,
    required this.isExpanded,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 300),
      firstChild: Divider(
        thickness: 0.5,
        endIndent: 0,
        height: 10,
      ),
      secondChild: Divider(
        thickness: 0.5,
        endIndent: kDividerEndIndent,
        height: 10,
      ),
      crossFadeState:
          isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
