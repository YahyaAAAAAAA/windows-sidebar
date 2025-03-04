import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

class SideButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final String text;

  const SideButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(GColors.windowColor.shade600),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kOuterRadius),
              ),
            ),
          ),
          icon: Icon(
            icon,
            size: 20,
            color: GColors.windowColor.shade100,
          ),
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            color: GColors.windowColor.shade100,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
