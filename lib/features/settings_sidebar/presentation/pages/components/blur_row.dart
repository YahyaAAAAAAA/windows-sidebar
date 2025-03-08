import 'package:flutter/material.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';

class BlurRow extends StatelessWidget {
  final bool blurValue;
  final bool borderValue;
  final void Function(bool?)? onBlurChanged;
  final void Function(bool?)? onBorderChanged;

  const BlurRow({
    super.key,
    required this.blurValue,
    required this.borderValue,
    this.onBlurChanged,
    this.onBorderChanged,
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
              'Sidebar Blur',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Expanded(
              flex: 5,
              child: SideDivider(isExpanded: true),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Blur',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Checkbox(
              value: blurValue,
              onChanged: onBlurChanged,
            ),
            Text(
              'Border',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Checkbox(
              value: borderValue,
              onChanged: onBorderChanged,
            ),
          ],
        ),
      ],
    );
  }
}
