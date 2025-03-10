import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/extensions/theme_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor.shade600,
              Theme.of(context).scaffoldBackgroundColor.shade700,
            ],
          ),
          border: Border.all(
            color: Theme.of(context).extension<BorderExtension>()!.color,
            width: Theme.of(context)
                .extension<BorderExtension>()!
                .globalBorderWidth,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kOuterRadius),
            bottomLeft: Radius.circular(kOuterRadius),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kOuterRadius),
            bottomLeft: Radius.circular(kOuterRadius),
          ),
          child: Scaffold(
            backgroundColor: GColors.transparent,
            body: Padding(
              padding: const EdgeInsets.all(6),
              child: body,
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
    //   appBar: appBar,
    //   body: MeshGradient(
    //     options: MeshGradientOptions(
    //       noiseIntensity: 0,
    //     ),
    //     points: points,
    //     child: body,
    //   ),
    //   backgroundColor: backgroundColor,
    //   bottomNavigationBar: bottomNavigationBar,
    // );
  }
}
