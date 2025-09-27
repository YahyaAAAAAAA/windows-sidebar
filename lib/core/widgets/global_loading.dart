import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';

class GlobalLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final double? maxWidth;
  final double? minWidth;
  final double? minHeight;
  final double? maxHeight;
  final AlignmentGeometry? alignment;
  final bool surface;

  const GlobalLoading({
    super.key,
    this.width = 20,
    this.height = 20,
    this.maxHeight,
    this.minHeight,
    this.maxWidth,
    this.minWidth,
    this.alignment = Alignment.center,
    this.surface = false,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? double.infinity,
        maxHeight: maxHeight ?? double.infinity,
        minHeight: minHeight ?? 0,
        minWidth: minWidth ?? 0,
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 300),
        alignment: alignment!,
        child: SizedBox(
          width: width,
          height: height,
          child: CircularProgressIndicator(
            color:
                surface
                    ? context.theme.colorScheme.surface
                    : context.theme.iconTheme.color,
          ),
        ),
      ),
    );
  }
}
