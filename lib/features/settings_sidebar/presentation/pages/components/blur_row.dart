import 'package:flutter/material.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';

class BlurRow extends StatelessWidget {
  final bool radioValue;
  final void Function(bool?)? onBlur;
  final void Function(bool?)? onNoBlur;

  const BlurRow({
    super.key,
    required this.radioValue,
    this.onBlur,
    this.onNoBlur,
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
            Radio(
              value: radioValue,
              groupValue: true,
              onChanged: onBlur,
            ),
            Text(
              'No Blur',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            Radio(
              value: radioValue,
              groupValue: false,
              onChanged: onNoBlur,
            ),
          ],
        ),
      ],
    );
  }
}
