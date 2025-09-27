import 'package:flutter/material.dart';
import 'package:windows_widgets/core/widgets/app/app_center.dart';
import 'package:windows_widgets/core/widgets/app/app_fitted_box.dart';

class AppRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;
  final bool isCentered;
  final bool isFitted;
  final BoxFit fit;
  final Alignment alignment;

  const AppRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.min,
    this.spacing = 0.0,
    this.isCentered = false,
    this.isFitted = false,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return AppCenter(
      enabled: isCentered,
      child: AppFittedBox(
        enabled: isFitted,
        alignment: alignment,
        fit: fit,
        child: Row(mainAxisAlignment: mainAxisAlignment, crossAxisAlignment: crossAxisAlignment, spacing: spacing, children: children),
      ),
    );
  }
}
