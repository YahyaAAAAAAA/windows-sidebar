import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

//applies fade effect at the top and bottom of it's child
class FadeEffect extends StatelessWidget {
  final Widget child;

  const FadeEffect({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            GColors.transparent,
            GColors.transparent,
            Theme.of(context).scaffoldBackgroundColor,
          ],
          stops: [
            0.0,
            0.1,
            0.9,
            1.0
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: child,
    );
  }
}
