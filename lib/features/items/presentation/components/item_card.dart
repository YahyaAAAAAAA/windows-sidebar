import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/packages/spring_curve/spring_curve.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/app/buttons/subtle_button.dart';
import 'package:windows_widgets/core/widgets/overflow_tooltip_text.dart';
import 'package:windows_widgets/features/items/domain/models/app_file.dart';
import 'package:windows_widgets/features/items/domain/models/app_folder.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';
import 'package:windows_widgets/features/items/domain/models/app_url.dart';

Duration animationDuration = kDuration.fast;

class ItemCard extends StatelessWidget {
  final AppItem item;
  final bool isExpanded;
  final bool canDrag;
  final void Function(BuildContext context, Offset position)? onRightClick;
  final void Function()? onLeftClick;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;
  final void Function(bool)? onFocusChange;

  const ItemCard({
    super.key,
    required this.item,
    required this.isExpanded,
    required this.canDrag,
    this.onRightClick,
    this.onEnter,
    this.onExit,
    this.onLeftClick,
    this.onFocusChange,
  });

  double setWidthOnHover() {
    final double width = isExpanded ? kDashHori.widthExpanded : kDashHori.width;
    final double hoveredWidth = isExpanded ? kDashHori.widthExpandedHovered : kDashHori.widthHovered;

    return item.isHovered ? hoveredWidth : width;
  }

  Color setColorOnHover(AppItem item, BuildContext context) {
    final Color width = context.theme.disabledColor;
    final Color hoveredWidth = context.theme.primaryColor;

    return item.isHovered ? hoveredWidth : width;
  }

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
      width: isExpanded ? calculateTextWidth(item.name) + kItemButton.width : kItemButton.width,
      constraints: BoxConstraints(maxWidth: kItemButton.maxWidth),
      onFocusChange: onFocusChange,
      borderWidth: 0,
      child: Stack(
        children: [
          MouseRegion(
            onEnter: onEnter,
            onExit: onExit,
            child: GestureDetector(
              onSecondaryTapDown: (details) async {
                if (onRightClick != null) {
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  var position = renderBox.localToGlobal(details.localPosition);
                  position = Offset(position.dx, position.dy);
                  onRightClick!(context, position);
                }
              },
              child: SubtleButton(
                width: isExpanded ? calculateTextWidth(item.name) + kItemButton.width : kItemButton.width,
                height: kItemButton.height,
                onPressed: onLeftClick,
                constraints: BoxConstraints(maxWidth: kItemButton.maxWidth),
                padding: kPadding.medium.pAll,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //to center the icon when not expanded
                    AppContainer(
                      width: !isExpanded ? kGap.small : 0,
                      height: 0,
                      isAnimated: true,
                      duration: animationDuration,
                      borderWidth: 0,
                    ),

                    //build icon
                    itemBuild(item, context),

                    //gap between icon and text
                    AppContainer(
                      width: isExpanded ? kGap.medium : 0,
                      height: 0,
                      isAnimated: true,
                      duration: animationDuration,
                      borderWidth: 0,
                    ),

                    //name
                    OverflowTooltipText(
                      maxWidth: kItemButton.maxWidth - kItemButton.width,
                      text: item.name,
                      style: context.theme.textTheme.labelSmall,
                      expandOnlyOverflowText: false,
                      disabled: !isExpanded,
                    ),
                  ],
                ),
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
                // duration: animationDuration,
                borderWidth: 0,
              ),
            ),
          ),
          //drag handle
          canDrag
              ? Positioned(
                  right: kGap.small,
                  child: Icon(Icons.drag_handle_rounded, size: kIconSize.tiny, color: setColorOnHover(item, context)),
                )
              : 0.width,
        ],
      ),
    );
  }

  Widget itemBuild(AppItem item, BuildContext context) {
    if (item is AppFile) {
      return fileBuild(item);
    }
    if (item is AppUrl) {
      return urlBuild(item);
    }
    if (item is AppFolder) {
      return folderBuild(item, context);
    }

    return const Icon(Icons.error_outline);
  }

  Widget fileBuild(AppFile file) {
    return SizedBox(
      width: kItem.width,
      height: kItem.height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: AnimatedScale(
          duration: kDuration.long,
          curve: ElegantSpring.windows,
          scale: file.isHovered ? kItem.scaled : kItem.notScaled,
          child: file.icon != null
              ? Image.memory(file.icon!, width: kItem.width - 8, height: kItem.height - 8)
              : Image.asset(kAsset.file, width: kItem.width - 8, height: kItem.height - 8),
        ),
      ),
    );
  }

  Widget folderBuild(AppFolder folder, BuildContext context) {
    return Stack(
      children: [
        AnimatedCrossFade(
          duration: animationDuration,
          crossFadeState: folder.isHovered ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Transform.scale(
            scale: 1.2,
            child: Image.asset(
              kAsset.folderOpen,
              width: kItem.width,
              height: kItem.height,
              key: ValueKey(folder.isHovered),
            ),
          ),
          secondChild: Transform.scale(
            scale: 1.2,
            child: Image.asset(
              kAsset.folder,
              alignment: Alignment.centerLeft,
              width: kItem.width,
              height: kItem.height,
              key: ValueKey(folder.isHovered),
            ),
          ),
        ),
        Padding(
          padding: folder.isHovered
              ? EdgeInsets.only(left: folder.name[0].toUpperCase() == 'M' ? 12 : 15, top: 8)
              : EdgeInsets.only(left: folder.name[0].toUpperCase() == 'M' ? 8 : 12, top: 6),
          child: Transform(
            transform: folder.isHovered ? Matrix4.skew(-0.4, 0) : Matrix4.skew(0, 0),
            child: LabelMediumText(
              folder.name[0].toUpperCase(),
              config: const AppTextConfiguration(
                color: Color(0xFFcf8d00), //the image color but darker
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget urlBuild(AppUrl url) {
    return SizedBox(
      width: kItem.width,
      height: kItem.height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: AnimatedScale(
          duration: kDuration.long,
          curve: ElegantSpring.windows,
          scale: url.isHovered ? kItem.scaled : kItem.notScaled,
          child: url.icon != null
              ? Image.memory(url.icon!, width: kItem.width - 8, height: kItem.height - 8)
              : Image.asset(kAsset.url, width: kItem.width - 8, height: kItem.height - 8),
        ),
      ),
    );
  }
}
