import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
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
    return FittedBox(
      child: Row(
        children: [
          Column(
            children: [
              IconButton(
                onPressed: onLogoPressed,
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
                  Custom.apps,
                  size: 20,
                  color: GColors.windowColor.shade100,
                ),
              ),
              SizedBox(height: 3),
              //small button
              SizedBox(
                height: 20,
                child: IconButton(
                  onPressed: onExpandPressed,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(GColors.windowColor.shade600),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kOuterRadius)),
                    ),
                  ),
                  icon: Icon(
                    isExpanded
                        ? Icons.arrow_back_ios_new_outlined
                        : Icons.arrow_forward_ios_rounded,
                    size: 15,
                    color: GColors.windowColor.shade100,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 5),
          Text(
            'Windows Sidebar',
            style: TextStyle(
              color: GColors.windowColor.shade100,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 5),
          Container(
            decoration: BoxDecoration(
              color: GColors.windowColor.shade600,
              borderRadius: BorderRadius.circular(kOuterRadius),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              spacing: 2,
              children: [
                SideSmallButton(
                  onPressed: onSettingsPressed,
                  icon: Icons.settings,
                ),
                SideSmallButton(
                  onPressed: onReorderPressed,
                  icon: canDrag ? Icons.check : Custom.apps_sort,
                  tooltip: 'Reorder Items',
                  iconSize: 12,
                ),
                SideSmallButton(
                  onPressed: onPinPressed,
                  icon: isPinned ? Custom.unpin : Custom.pin,
                  tooltip: isPinned ? 'Unpin Sidebar' : 'Pin Sidebar',
                  iconSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
