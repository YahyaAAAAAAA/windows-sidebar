import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';
import 'package:windows_widgets/config/utils/widgets/overflow_tooltip_text.dart';

enum SideItemType {
  folder,
  file,
  none,
}

class SideItemCard extends StatelessWidget {
  final int index;
  final void Function(BuildContext context, Offset position)? onRightClick;

  final SideFolder? folder;
  final IconData? icon;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  const SideItemCard.folder({
    super.key,
    required this.folder,
    required this.icon,
    required this.index,
    this.onRightClick,
    this.onEnter,
    this.onExit,
  }) : file = null;

  final SideFile? file;
  const SideItemCard.file({
    super.key,
    required this.file,
    required this.index,
    this.onRightClick,
  })  : folder = null,
        icon = null,
        onEnter = null,
        onExit = null;

  SideItemType decide() {
    if (folder == null) {
      return SideItemType.file;
    } else if (file == null) {
      return SideItemType.folder;
    } else {
      return SideItemType.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onSecondaryTapDown: (details) async {
            if (onRightClick != null) {
              final RenderBox renderBox =
                  context.findRenderObject() as RenderBox;
              var position = renderBox.localToGlobal(details.localPosition);
              position = Offset(0, position.dy);
              onRightClick!(context, position);
            }
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: IconButton(
              style: ButtonStyle(
                backgroundColor:
                    WidgetStatePropertyAll(GColors.windowColor.shade600),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kOuterRadius),
                  ),
                ),
              ),
              onPressed: () => decide() == SideItemType.folder
                  ? Picker.openFolder(folder?.path, context)
                  //todo openFile method
                  : Picker.openFolder(file?.path, context),
              icon:
                  decide() == SideItemType.folder ? folderBuild() : fileBuild(),
            ),
          ),
        ),
        SizedBox(width: 10),
        //showed only when sidebar is extended
        OverflowTooltipText(
          text: decide() == SideItemType.folder ? folder!.name : file!.name,
          maxWidth: kMaxTextWidth,
          style: TextStyle(
            color: GColors.windowColor.shade100,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),

        SizedBox(width: 26),
      ],
    );
  }

  Widget fileBuild() {
    return Transform.scale(
      scale: 1.7,
      child: Image.memory(
        file!.icon!,
        width: 16,
        height: 16,
      ),
    );
  }

  Widget folderBuild() {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      child: Stack(
        children: [
          Icon(
            folder!.icon,
            size: 24,
            key: ValueKey(folder!.icon),
            color: GColors.windowColor.shade100,
          ),
          Padding(
            padding: folder!.icon == Custom.folder_fill
                ? EdgeInsets.only(
                    left: 4,
                    top: 7,
                  )
                : EdgeInsets.only(
                    left: 10,
                    top: 7,
                  ),
            child: Transform(
              transform: folder!.icon == Custom.folder_fill
                  ? Matrix4.skew(0, 0)
                  : Matrix4.skew(-0.4, 0),
              child: Text(
                folder!.name[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  color: GColors.windowColor.shade600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
