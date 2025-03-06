import 'package:flutter/material.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';

class ThemeRow extends StatelessWidget {
  final int selectedTheme;
  final void Function(int?)? onLightSelected;
  final void Function(int?)? onDarkSelected;
  final void Function(int?)? onDeviceSelected;

  const ThemeRow({
    super.key,
    required this.selectedTheme,
    this.onLightSelected,
    this.onDarkSelected,
    this.onDeviceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: SideDivider(isExpanded: true)),
            Text(
              'Sidebar Theme',
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
                'Light',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Radio(
                value: selectedTheme,
                groupValue: 0,
                onChanged: onLightSelected,
              ),
              Text(
                'Dark',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Radio(
                value: selectedTheme,
                groupValue: 1,
                onChanged: onDarkSelected,
              ),
              Text(
                'Device',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Radio(
                value: selectedTheme,
                groupValue: 2,
                onChanged: onDeviceSelected,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
