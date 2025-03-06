import 'package:flutter/material.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';

class OpacityRow extends StatelessWidget {
  final double sliderValue;
  final void Function(double)? onChanged;

  const OpacityRow({
    super.key,
    required this.sliderValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SideDivider(isExpanded: true),
            ),
            Text(
              'Sidebar Opacity',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Expanded(
              flex: 5,
              child: SideDivider(isExpanded: true),
            ),
          ],
        ),
        Transform.scale(
          scale: 0.7,
          alignment: Alignment.centerLeft,
          child: Slider(
            value: sliderValue,
            max: 1,
            min: 0,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
