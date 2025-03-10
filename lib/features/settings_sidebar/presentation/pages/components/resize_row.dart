import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';
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
            style: Theme.of(context).textTheme.labelMedium,
          ),
          SizedBox(width: 5),
          //note elevation on a Container
          PhysicalModel(
            color: Theme.of(context).secondaryHeaderColor,
            elevation: Theme.of(context)
                    .iconButtonTheme
                    .style
                    ?.elevation
                    ?.resolve({}) ??
                0,
            borderRadius: BorderRadius.circular(kOuterRadius),
            child: Row(
              children: [
                Column(
                  children: [
                    SideSmallButton(
                      onPressed:
                          windowHeight >= kWindowMaxHeight ? null : onUpPressed,
                      icon: windowHeight >= kWindowMaxHeight
                          ? Icons.horizontal_rule_rounded
                          : Icons.arrow_drop_up_rounded,
                      buttonStyle: Theme.of(context)
                          .iconButtonTheme
                          .style
                          ?.copyWith(elevation: WidgetStatePropertyAll(0)),
                    ),
                    SideSmallButton(
                      onPressed: windowHeight <= kWindowMinHeight
                          ? null
                          : onDownPressed,
                      icon: windowHeight <= kWindowMinHeight
                          ? Icons.horizontal_rule_rounded
                          : Icons.arrow_drop_down_rounded,
                      buttonStyle: Theme.of(context)
                          .iconButtonTheme
                          .style
                          ?.copyWith(elevation: WidgetStatePropertyAll(0)),
                    ),
                  ],
                ),
                Text(
                  windowHeight.ceil().toInt().toString(),
                  style: Theme.of(context).textTheme.labelSmall,
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
