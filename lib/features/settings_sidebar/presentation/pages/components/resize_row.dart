import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          'Sidebar Height',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor.shade600,
                border: Border.all(
                  color: Theme.of(context).primaryColor.shade300,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(kOuterRadius),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      SideSmallButton.icon(
                        onPressed: windowHeight >= kWindowMaxHeight
                            ? null
                            : onUpPressed,
                        icon: windowHeight >= kWindowMaxHeight
                            ? Icons.horizontal_rule_rounded
                            : Icons.arrow_drop_up_rounded,
                        buttonStyle: Theme.of(context)
                            .iconButtonTheme
                            .style
                            ?.copyWith(
                                side: WidgetStatePropertyAll(BorderSide.none)),
                      ),
                      SideSmallButton.icon(
                        onPressed: windowHeight <= kWindowMinHeight
                            ? null
                            : onDownPressed,
                        icon: windowHeight <= kWindowMinHeight
                            ? Icons.horizontal_rule_rounded
                            : Icons.arrow_drop_down_rounded,
                        buttonStyle: Theme.of(context)
                            .iconButtonTheme
                            .style
                            ?.copyWith(
                                side: WidgetStatePropertyAll(BorderSide.none)),
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
            SideSmallButton.icon(
              onPressed: onDonePressed,
              icon: Icons.check,
              height: 40,
              tooltip: 'Resize',
              buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                        Theme.of(context).scaffoldBackgroundColor.shade600),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Theme.of(context).primaryColor.shade300,
                        width: 0.5,
                      ),
                    ),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
