import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windows_widgets/config/enums/side_item_type.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';

class SideItemCard extends StatelessWidget {
  final bool isExpanded;
  final int index;
  final void Function(BuildContext context, Offset position)? onRightClick;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  final SideFolder? folder;
  const SideItemCard.folder({
    super.key,
    required this.isExpanded,
    required this.folder,
    required this.index,
    this.onRightClick,
    this.onEnter,
    this.onExit,
  })  : file = null,
        fileIconScale = null;

  final SideFile? file;
  final double? fileIconScale;
  const SideItemCard.file({
    super.key,
    required this.isExpanded,
    required this.file,
    required this.index,
    this.onRightClick,
    this.fileIconScale,
    this.onEnter,
    this.onExit,
  }) : folder = null;

  SideItemType decide() {
    if (folder == null) {
      return SideItemType.file;
    } else if (file == null) {
      return SideItemType.folder;
    } else {
      return SideItemType.none;
    }
  }

  double setHeightOnHover() {
    if (decide() == SideItemType.folder) {
      return folder!.localIcon == Custom.folder_open_fill ? 20 : 0;
    } else {
      return file!.scale == 1.8 ? 20 : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(kOuterRadius),
          onTap: () => Picker.openItem(file ?? folder, context),
          onSecondaryTapDown: (details) async {
            if (onRightClick != null) {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              var position = renderBox.localToGlobal(details.localPosition);
              position = Offset(0, position.dy);
              onRightClick!(context, position);
            }
          },
          child: MouseRegion(
            onEnter: onEnter,
            onExit: onExit,
            child: Row(
              mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
              children: [
                AnimatedContainer(
                  margin:
                      EdgeInsets.only(left: setHeightOnHover() != 0 ? 2 : 0),
                  duration: Duration(milliseconds: 300),
                  width: 2,
                  height: setHeightOnHover(),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kOuterRadius),
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    right: 5,
                    left: 2,
                  ),
                  child: decide() == SideItemType.folder
                      ? folderBuild(context)
                      : fileBuild(),
                ),
                //showed only when sidebar is extended

                isExpanded ? SizedBox(width: 10) : SizedBox(),

                isExpanded
                    ? Expanded(
                        child: Text(
                          decide() == SideItemType.folder
                              ? folder!.name
                              : file!.name,
                          style: Theme.of(context).textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    : SizedBox(),

                isExpanded ? SizedBox(width: 26) : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fileBuild() {
    return SizedBox(
      width: 30,
      height: 30,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: AnimatedScale(
          duration: Duration(milliseconds: 300),
          scale: fileIconScale ?? 1.7,
          child: Image.memory(
            file!.icon!,
            width: 16,
            height: 16,
          ),
        ),
      ),
    );
  }

  Widget folderBuild(BuildContext context) {
    return Stack(
      children: [
        AnimatedCrossFade(
          duration: Duration(milliseconds: 300),
          crossFadeState: folder!.localIcon == Custom.folder_fill
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          firstChild: Image.asset(
            'assets/images/folder_open.png',
            width: 30,
            height: 30,
            key: ValueKey(folder!.localIcon),
          ),
          secondChild: Image.asset(
            'assets/images/folder.png',
            alignment: Alignment.centerLeft,
            width: 30,
            height: 30,
            key: ValueKey(folder!.localIcon),
          ),
        ),
        Padding(
          padding: folder!.localIcon == Custom.folder_fill
              ? EdgeInsets.only(left: 15, top: 10)
              : EdgeInsets.only(left: 20, top: 12),
          child: Transform(
            transform: folder!.localIcon == Custom.folder_fill
                ? Matrix4.skew(0, 0)
                : Matrix4.skew(-0.4, 0),
            child: Text(
              folder!.name[0].toUpperCase(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).iconTheme.color,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
