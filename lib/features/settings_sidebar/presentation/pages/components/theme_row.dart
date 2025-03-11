import 'package:flutter/material.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';

class ThemeRow extends StatelessWidget {
  final int selectedTheme;
  final void Function(int?)? onLightSelected;
  final void Function(int?)? onDarkSelected;
  final void Function(int?)? onDeviceSelected;
  final void Function(int?)? onDefaultSelected;

  const ThemeRow({
    super.key,
    required this.selectedTheme,
    this.onLightSelected,
    this.onDarkSelected,
    this.onDeviceSelected,
    this.onDefaultSelected,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    Text(
                      'Default',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Radio(
                      value: selectedTheme,
                      groupValue: 0,
                      onChanged: onDefaultSelected,
                    ),
                    Text(
                      'Device',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Radio(
                      value: selectedTheme,
                      groupValue: 1,
                      onChanged: onDeviceSelected,
                    ),
                  ],
                )),
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
                    groupValue: 2,
                    onChanged: onLightSelected,
                  ),
                  Text(
                    'Dark',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Radio(
                    value: selectedTheme,
                    groupValue: 3,
                    onChanged: onDarkSelected,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
