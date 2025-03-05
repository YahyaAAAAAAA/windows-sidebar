import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_small_button.dart';

class ResizeRow extends StatelessWidget {
  final double windowHeight;
  final void Function()? onUpPressed;
  final void Function()? onDownPressed;
  final void Function()? onDonePressed;

  const ResizeRow({
    super.key,
    required this.windowHeight,
    this.onUpPressed,
    this.onDownPressed,
    this.onDonePressed,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          Text(
            'Resize Sidebar',
            style: TextStyle(
              color: GColors.windowColor.shade100,
            ),
          ),
          SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              color: GColors.windowColor.shade600,
              borderRadius: BorderRadius.circular(kOuterRadius),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    SideSmallButton(
                      onPressed: onUpPressed,
                      icon: Icons.arrow_drop_up_rounded,
                    ),
                    SideSmallButton(
                      onPressed: onDownPressed,
                      icon: Icons.arrow_drop_down_rounded,
                    ),
                  ],
                ),
                Text(
                  windowHeight.ceil().toInt().toString(),
                  style: TextStyle(
                    color: GColors.windowColor.shade100,
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
          SizedBox(width: 5),
          SideSmallButton(
            onPressed: onDonePressed,
            icon: Icons.check,
            height: 40,
            tooltip: 'Resize',
          ),
        ],
      ),
    );
  }
}
