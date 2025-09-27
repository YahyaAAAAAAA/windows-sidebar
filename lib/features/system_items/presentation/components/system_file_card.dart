import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/packages/spring_curve/spring_curve.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/app/buttons/subtle_button.dart';
import 'package:windows_widgets/features/system_items/domain/models/system_item.dart';

Duration animationDuration = kDuration.medium;

class SystemItemCard extends StatelessWidget {
  final SystemItem item;
  final void Function()? onLeftClick;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final void Function(bool)? onFocusChange;
  final bool isWindowDragged;

  const SystemItemCard({
    super.key,
    required this.item,
    this.onEnter,
    this.onExit,
    this.onLeftClick,
    this.onFocusChange,
    this.isWindowDragged = false,
  });

  bool get isHovered => item.isHovered && !isWindowDragged;

  bool get isFocused => item.hasFocus && !isWindowDragged;

  double setWidthOnHover() => isHovered
      ? kDashHori.widthExpandedHovered
      : isFocused
      ? kDashHori.widthHovered
      : kDashHori.width;

  Color setColorOnHover(SystemItem item, BuildContext context) =>
      isHovered || isFocused ? context.theme.primaryColor : context.theme.disabledColor;

  double calculateTextWidth(String text) {
    final textPainter = TextPainter(
      text: TextSpan(text: text),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    return textPainter.width >= kItemButton.maxWidth ? (kItemButton.maxWidth - kItemButton.width) : textPainter.width;
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      height: kItemButton.height,
      width: isHovered ? calculateTextWidth(item.name) + kItemButton.width - kGap.medium : kItemButton.width,
      isAnimated: true,
      onFocusChange: onFocusChange,
      curve: ElegantSpring.windows,
      duration: kDuration.long,
      constraints: BoxConstraints(maxWidth: kItemButton.maxWidth),
      borderWidth: 0,
      child: Stack(
        children: [
          MouseRegion(
            onEnter: onEnter,
            onExit: onExit,
            child: SubtleButton(
              width: isHovered ? calculateTextWidth(item.name) + kItemButton.width - kGap.medium : kItemButton.width,
              height: kItemButton.height,
              onPressed: onLeftClick,
              constraints: BoxConstraints(maxWidth: kItemButton.maxWidth),
              padding: kPadding.medium.pAll,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  //to center the icon when not expanded
                  AppContainer(
                    width: !isHovered ? kGap.small : 0,
                    height: 0,
                    isAnimated: false,
                    duration: animationDuration,
                    color: Colors.transparent,
                    borderWidth: 0,
                  ),

                  //build icon
                  systemFileBuild(item, context),

                  isHovered ? 0.width : 5.width,

                  //name
                  Center(
                    child: LabelSmallText(
                      item.name,
                      config: const AppTextConfiguration(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //bottom dash
          Align(
            alignment: Alignment.bottomCenter,
            child: IgnorePointer(
              child: AppContainer(
                width: setWidthOnHover(),
                height: 3,
                color: setColorOnHover(item, context),
                isAnimated: true,
                curve: ElegantSpring.windows,
                duration: kDuration.long,
                borderWidth: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget systemFileBuild(SystemItem systemFile, BuildContext context) {
    return SizedBox(
      width: kItem.width,
      height: kItem.height,
      child: FittedBox(fit: BoxFit.scaleDown, child: Icon(systemFile.icon)),
    );
  }
}
