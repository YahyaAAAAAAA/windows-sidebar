import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_small_button.dart';

class HeaderRow extends StatelessWidget {
  final void Function()? onLogoPressed;
  final void Function()? onSettingsPressed;
  final void Function()? onExpandPressed;
  final void Function()? onReorderPressed;
  final void Function()? onPinPressed;
  final bool canDrag;
  final bool isExpanded;
  final bool isPinned;

  const HeaderRow({
    super.key,
    required this.canDrag,
    required this.isExpanded,
    required this.isPinned,
    this.onLogoPressed,
    this.onSettingsPressed,
    this.onExpandPressed,
    this.onReorderPressed,
    this.onPinPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Lottie.asset(
              'assets/animations/logo.json',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              frameRate: FrameRate(60),
              //note lottie color change
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.color(
                    const ['**'],
                    value: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
            ),
            SideSmallButton.icon(
              onPressed: onExpandPressed,
              width: 40,
              padding: EdgeInsets.symmetric(horizontal: 8),
              icon: isExpanded
                  ? Icons.arrow_back_rounded
                  : Icons.arrow_forward_rounded,
              iconSize: 15,
              buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                      side: WidgetStatePropertyAll(
                    BorderSide(
                      color: Theme.of(context).primaryColor.shade400,
                      width: 1,
                    ),
                  )),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SideSmallButton.icon(
                    onPressed: onPinPressed,
                    icon: isPinned ? Custom.unpin : Custom.pin,
                    tooltip: isPinned ? 'Unpin Sidebar' : 'Pin Sidebar',
                    iconSize: 12,
                    buttonStyle: Theme.of(context)
                        .iconButtonTheme
                        .style
                        ?.copyWith(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            side: WidgetStatePropertyAll(BorderSide.none)),
                  ),
                  SideSmallButton.icon(
                    onPressed: onReorderPressed,
                    icon: canDrag ? Icons.check : Custom.apps_sort,
                    tooltip: 'Reorder Items',
                    iconSize: 12,
                    buttonStyle: Theme.of(context)
                        .iconButtonTheme
                        .style
                        ?.copyWith(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            side: WidgetStatePropertyAll(BorderSide.none)),
                  ),
                  SideSmallButton.icon(
                    onPressed: onSettingsPressed,
                    icon: Icons.settings,
                    buttonStyle: Theme.of(context)
                        .iconButtonTheme
                        .style
                        ?.copyWith(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            side: WidgetStatePropertyAll(BorderSide.none)),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Windows Sidebar',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  //small button
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ],
    );
  }
}
