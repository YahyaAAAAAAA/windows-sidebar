import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windows_widgets/config/enums/side_item_type.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_url.dart';

class SideItemCard extends StatelessWidget {
  final bool isExpanded;
  final int index;
  final void Function(BuildContext context, Offset position)? onRightClick;
  final void Function()? onLeftClick;
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
    this.onLeftClick,
  })  : file = null,
        url = null;

  final SideFile? file;
  const SideItemCard.file({
    super.key,
    required this.isExpanded,
    required this.file,
    required this.index,
    this.onRightClick,
    this.onEnter,
    this.onExit,
    this.onLeftClick,
  })  : folder = null,
        url = null;

  final SideUrl? url;
  const SideItemCard.url({
    super.key,
    required this.url,
    required this.isExpanded,
    required this.index,
    this.onRightClick,
    this.onEnter,
    this.onExit,
    this.onLeftClick,
  })  : folder = null,
        file = null;

  SideItemType decide() {
    if (folder != null) {
      return SideItemType.folder;
    } else if (file != null) {
      return SideItemType.file;
    } else {
      return SideItemType.url;
    }
  }

  double setHeightOnHover() {
    if (decide() == SideItemType.folder) {
      return folder!.localIcon == Custom.folder_open_fill ? 20 : 0;
    } else if (decide() == SideItemType.file) {
      return file!.scale == 1.8 ? 20 : 0;
    } else {
      return url!.scale == 1.8 ? 20 : 0;
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
          onTap: onLeftClick,
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
                  padding: const EdgeInsets.all(5),
                  child: decide() == SideItemType.folder
                      ? folderBuild(context)
                      : decide() == SideItemType.file
                          ? fileBuild()
                          : urlBuild(),
                ),
                //showed only when sidebar is extended

                isExpanded ? SizedBox(width: 10) : SizedBox(),

                isExpanded
                    ? Expanded(
                        child: Text(
                          decide() == SideItemType.folder
                              ? folder!.name
                              : decide() == SideItemType.file
                                  ? file!.name
                                  : url!.name,
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
      width: 24,
      height: 24,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: AnimatedScale(
          duration: Duration(milliseconds: 300),
          scale: file!.scale ?? 1.7,
          child: file!.icon != null
              ? Image.memory(
                  file!.icon!,
                  width: 16,
                  height: 16,
                )
              : Image.asset(
                  'assets/images/file.png',
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
          firstChild: Transform.scale(
            scale: 1.2,
            child: Image.asset(
              'assets/images/folder_open.png',
              width: 24,
              height: 24,
              key: ValueKey(folder!.localIcon),
            ),
          ),
          secondChild: Transform.scale(
            scale: 1.2,
            child: Image.asset(
              'assets/images/folder.png',
              alignment: Alignment.centerLeft,
              width: 24,
              height: 24,
              key: ValueKey(folder!.localIcon),
            ),
          ),
        ),
        Padding(
          padding: folder!.localIcon == Custom.folder_fill
              ? EdgeInsets.only(
                  left: folder!.name[0].toUpperCase() == 'M' ? 8 : 10, top: 8)
              : EdgeInsets.only(
                  left: folder!.name[0].toUpperCase() == 'M' ? 12 : 15, top: 8),
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

  Widget urlBuild() {
    return SizedBox(
      width: 24,
      height: 24,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: AnimatedScale(
          duration: Duration(milliseconds: 300),
          scale: url!.scale ?? 1.7,
          child: url!.icon != null
              ? Image.memory(
                  url!.icon!,
                  width: 16,
                  height: 16,
                )
              : Image.asset(
                  'assets/images/url.png',
                  width: 16,
                  height: 16,
                ),
        ),
      ),
    );
  }
}
