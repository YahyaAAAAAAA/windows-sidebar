import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:windows_widgets/config/enums/side_item_type.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';
import 'package:windows_widgets/config/utils/widgets/overflow_tooltip_text.dart';

class SideItemCard extends StatelessWidget {
  final int index;
  final void Function(BuildContext context, Offset position)? onRightClick;
  final void Function(PointerEnterEvent)? onEnter;
  final void Function(PointerExitEvent)? onExit;

  final SideFolder? folder;
  const SideItemCard.folder({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onSecondaryTapDown: (details) async {
        if (onRightClick != null) {
          final RenderBox renderBox = context.findRenderObject() as RenderBox;
          var position = renderBox.localToGlobal(details.localPosition);
          position = Offset(0, position.dy);
          onRightClick!(context, position);
        }
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: IconButton(
              onPressed: () => Picker.openItem(folder ?? file, context),
              icon: decide() == SideItemType.folder
                  ? folderBuild(context)
                  : fileBuild(),
              style: ButtonStyle(
                elevation: WidgetStatePropertyAll(2),
              ),
            ),
          ),
          SizedBox(width: 10),
          //showed only when sidebar is extended
          OverflowTooltipText(
            text: decide() == SideItemType.folder ? folder!.name : file!.name,
            maxWidth: kMaxTextWidth,
            style: Theme.of(context).textTheme.labelMedium,
          ),

          SizedBox(width: 26),
        ],
      ),
    );
  }

  Widget fileBuild() {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      child: AnimatedScale(
        duration: Duration(milliseconds: 200),
        scale: fileIconScale ?? 1.7,
        child: Image.memory(
          file!.icon!,
          width: 16,
          height: 16,
        ),
      ),
    );
  }

  Widget folderBuild(BuildContext context) {
    return MouseRegion(
      onEnter: onEnter,
      onExit: onExit,
      child: Stack(
        children: [
          Icon(
            folder!.localIcon,
            size: 24,
            key: ValueKey(folder!.localIcon),
          ),
          Padding(
            padding: folder!.localIcon == Custom.folder_fill
                ? EdgeInsets.only(
                    left: 4,
                    top: 7,
                  )
                : EdgeInsets.only(
                    left: 10,
                    top: 7,
                  ),
            child: Transform(
              transform: folder!.localIcon == Custom.folder_fill
                  ? Matrix4.skew(0, 0)
                  : Matrix4.skew(-0.4, 0),
              child: Text(
                folder!.name[0].toUpperCase(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
