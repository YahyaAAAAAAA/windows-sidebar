import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Sidebar Theme',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            iconStyleData: IconStyleData(
              icon: Icon(
                Icons.arrow_drop_down_rounded,
              ),
              iconEnabledColor: Theme.of(context).iconTheme.color,
            ),
            buttonStyleData: ButtonStyleData(
              width: 75,
              height: 40,
              padding: EdgeInsets.only(left: 3),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.shade600,
                borderRadius: BorderRadius.circular(kOuterRadius),
                border: Border.all(
                  color: Theme.of(context).primaryColor.shade400,
                ),
              ),
            ),
            dropdownStyleData: DropdownStyleData(
              width: 75,
              elevation: 1,
              offset: Offset(0, -5),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.shade600,
                borderRadius: BorderRadius.circular(kOuterRadius),
              ),
            ),
            style:
                Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 11),
            items: [
              DropdownMenuItem(
                value: 0,
                child: Text(
                  'Default',
                ),
              ),
              DropdownMenuItem(
                value: 1,
                child: Text(
                  'Device',
                ),
              ),
              DropdownMenuItem(
                value: 2,
                child: Text(
                  'Light',
                ),
              ),
              DropdownMenuItem(
                value: 3,
                child: Text(
                  'Dark',
                ),
              ),
            ],
            value: selectedTheme,
            onChanged: (value) {
              switch (value) {
                case 0:
                  if (onDefaultSelected != null) onDefaultSelected!(value);
                  break;
                case 1:
                  if (onDeviceSelected != null) onDeviceSelected!(value);
                  break;
                case 2:
                  if (onLightSelected != null) onLightSelected!(value);
                  break;
                case 3:
                  if (onDarkSelected != null) onDarkSelected!(value);
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
}
