import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';

//used in pair with Skeleton.replace
class SkeletonContainer extends StatelessWidget {
  final Color? color;
  final double? width;
  final double? height;
  final double? borderRadius;

  const SkeletonContainer({
    super.key,
    this.color,
    this.borderRadius,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? kBorderRadius.outer),
      child: Container(
        color: color ?? context.theme.cardColor,
        width: width ?? 120,
        height: height ?? 10,
      ),
    );
  }
}
