import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/app/buttons/primary_button.dart';

class InformationDialog extends StatelessWidget {
  final String? title;
  final bool? bottomSpacing;
  final void Function()? onSavePressed;
  final void Function()? onCancelPressed;

  //title bar
  final List<Widget> topbarChildren;
  final MainAxisAlignment topbarMainAxisAlignment;
  final CrossAxisAlignment topbarCrossAxisAlignment;
  final MainAxisSize topbarMainAxisSize;
  final double topbarSpacing;

  //content
  final List<Widget> contentChildren;
  final MainAxisAlignment contentMainAxisAlignment;
  final CrossAxisAlignment contentCrossAxisAlignment;
  final MainAxisSize contentMainAxisSize;
  final double contentSpacing;

  const InformationDialog({
    super.key,
    this.title,
    this.onSavePressed,
    this.onCancelPressed,
    this.topbarChildren = const [],
    this.topbarMainAxisAlignment = MainAxisAlignment.start,
    this.topbarCrossAxisAlignment = CrossAxisAlignment.center,
    this.topbarMainAxisSize = MainAxisSize.max,
    this.topbarSpacing = 0,
    this.contentChildren = const [],
    this.contentMainAxisAlignment = MainAxisAlignment.center,
    this.contentCrossAxisAlignment = CrossAxisAlignment.center,
    this.contentMainAxisSize = MainAxisSize.min,
    this.contentSpacing = 20,
    this.bottomSpacing = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.theme.cardColor,
      contentPadding: 0.pAll,
      actionsAlignment: MainAxisAlignment.end,
      content: AppContainer(
        padding: kPadding.medium.pAll,
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kBorderRadius.outer),
          topRight: Radius.circular(kBorderRadius.outer),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: contentMainAxisAlignment,
            crossAxisAlignment: contentCrossAxisAlignment,
            mainAxisSize: contentMainAxisSize,
            spacing: contentSpacing,
            children: [
              Row(
                mainAxisAlignment: topbarMainAxisAlignment,
                crossAxisAlignment: topbarCrossAxisAlignment,
                mainAxisSize: topbarMainAxisSize,
                spacing: topbarSpacing,
                children: [
                  TitleMediumText(title ?? 'Title:'),
                  ...topbarChildren,
                ],
              ),

              //main children
              ...contentChildren,

              bottomSpacing! ? 20.height : 0.height,
            ],
          ),
        ),
      ),
      actions: [
        PrimaryButton(
          onPressed: onCancelPressed ?? () => context.pop(),
          width: kDialogButton.width,
          height: kDialogButton.height,
          child: const BodySmallText(
            'Back',
            config: AppTextConfiguration(surface: true),
          ),
        ),
      ],
    );
  }
}
