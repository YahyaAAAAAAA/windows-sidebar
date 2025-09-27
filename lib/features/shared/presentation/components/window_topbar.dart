import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/buttons/ghost_button.dart';

class WindowTopBar extends StatelessWidget {
  final Widget child;
  final List<Widget> titleChildren;
  final VoidCallback? onMinimize;
  final VoidCallback? onClose;

  const WindowTopBar({
    super.key,
    required this.child,
    this.titleChildren = const [],
    this.onClose,
    this.onMinimize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: kPadding.small.pAll,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: kGap.small,
            children: [
              ...titleChildren,
              //minimize
              GhostButton(
                onPressed: onMinimize,
                width: kBarButton.width,
                height: kBarButton.height,
                child: Icon(
                  FluentIcons.subtract_24_filled,
                  size: kIconSize.micro,
                ),
              ),
              //close
              GhostButton(
                onPressed: onClose,
                width: kBarButton.width,
                height: kBarButton.height,
                child: Icon(
                  FluentIcons.dismiss_24_filled,
                  size: kIconSize.micro,
                ),
              ),
            ],
          ),
        ),
        child,
      ],
    );
  }
}
