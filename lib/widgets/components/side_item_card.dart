import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/models/side_file.dart';
import 'package:windows_widgets/models/side_folder.dart';
import 'package:windows_widgets/config/utils/overflow_tooltip_text.dart';

enum SideItemType {
  folder,
  file,
  none,
}

class SideItemCard extends StatelessWidget {
  final SideFolder? folder;
  final SideFile? file;
  final void Function(BuildContext context, Offset position)? onRightClick;

  const SideItemCard.folder({
    super.key,
    required this.folder,
    this.onRightClick,
  }) : file = null;

  const SideItemCard.file({
    super.key,
    required this.file,
    this.onRightClick,
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
            icon: decide() == SideItemType.folder ? folderBuild() : fileBuild(),
          ),
        ),
        SizedBox(width: 10),
        //showed only when sidebar is extended
        OverflowTooltipText(
          text: decide() == SideItemType.folder ? folder!.name : file!.name,
          style: TextStyle(
            color: GColors.windowColor.shade100,
            fontWeight: FontWeight.w600,
            overflow: TextOverflow.ellipsis,
          ),
        ),
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
    return Stack(
      children: [
        Icon(
          Icons.folder,
          color: GColors.windowColor.shade100,
        ),
        Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            folder!.name[0].toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              color: GColors.windowColor.shade600,
            ),
          ),
        ),
      ],
    );
  }
}
