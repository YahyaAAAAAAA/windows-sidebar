import 'package:flutter/material.dart';
import 'package:windows_widgets/core/widgets/app/app_center.dart';
import 'package:windows_widgets/core/widgets/app/app_fitted_box.dart';

class AppColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;
  final bool isScrollable;
  final bool isCentered;
  final bool isFitted;
  final BoxFit fit;
  final Alignment alignment;

  const AppColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.spacing = 0.0,
    this.isScrollable = false,
    this.isCentered = false,
    this.isFitted = false,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return _AppSingleChildScrollView(
      enabled: isScrollable,
      child: AppCenter(
        enabled: isCentered,
        child: AppFittedBox(
          enabled: isFitted,
          fit: fit,
          child: Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            spacing: spacing,
            children: children,
          ),
        ),
      ),
    );
  }
}

//if more widgets used this, i'll make it public
class _AppSingleChildScrollView extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const _AppSingleChildScrollView({required this.child, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return enabled ? SingleChildScrollView(child: child) : child;
  }
}
