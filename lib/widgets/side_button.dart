import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

class SideButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;

  const SideButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(GColors.windowColor.shade600),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kOutterRadius),
          ),
        ),
      ),
      icon: Icon(
        icon,
        size: 20,
        color: GColors.windowColor.shade100,
      ),
    );
  }
}
