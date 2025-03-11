import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/double_exensions.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';

class PaddingRow extends StatelessWidget {
  final double scaffoldPadding;

  final void Function(bool?)? onChanged;

  const PaddingRow({
    super.key,
    required this.scaffoldPadding,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: SideDivider(isExpanded: true)),
            Text(
              'When Hidden',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Expanded(flex: 5, child: SideDivider(isExpanded: true)),
          ],
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Text(
                'Hide Sidebar By 1 Pixel',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Checkbox(
                value: scaffoldPadding.toBool(),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
