import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

class HeaderRow extends StatelessWidget {
  final void Function()? onLogoPressed;
  final void Function()? onSettingsPressed;
  final void Function()? onExpandPressed;
  final void Function()? onReorderPressed;
  final IconData expandIcon;
  final bool canDrag;

  const HeaderRow({
    super.key,
    required this.expandIcon,
    required this.canDrag,
    this.onLogoPressed,
    this.onSettingsPressed,
    this.onExpandPressed,
    this.onReorderPressed,
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
                    expandIcon,
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
          ColoredBox(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: IconButton(
                    onPressed: onSettingsPressed,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(GColors.windowColor.shade600),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kOuterRadius)),
                      ),
                    ),
                    icon: Icon(
                      Icons.settings,
                      size: 15,
                      color: GColors.windowColor.shade100,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                SizedBox(
                  height: 20,
                  width: 20,
                  child: IconButton(
                    onPressed: onReorderPressed,
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(GColors.windowColor.shade600),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kOuterRadius)),
                      ),
                    ),
                    icon: Icon(
                      canDrag ? Icons.check : Icons.drag_indicator_rounded,
                      size: 15,
                      color: GColors.windowColor.shade100,
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
