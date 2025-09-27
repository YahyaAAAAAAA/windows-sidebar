import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';

class AppSkeletonizer extends StatelessWidget {
  final Widget child;
  final Color? containersColor;
  final Color? baseColor;
  final bool enabled;
  final bool? enableSwitchAnimation;

  const AppSkeletonizer({
    super.key,
    required this.child,
    this.containersColor,
    this.baseColor,
    this.enabled = false,
    this.enableSwitchAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: enabled,
      enableSwitchAnimation: enableSwitchAnimation,
      containersColor: containersColor ?? context.theme.cardColor,
      effect: ShimmerEffect(
        baseColor:
            baseColor ?? context.theme.disabledColor.withValues(alpha: 0.1),
      ),
      child: child,
    );
  }
}
