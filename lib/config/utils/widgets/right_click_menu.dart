import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

Future<String?> showContextMenu(
  BuildContext context,
  Offset position,
  bool isExpanded, {
  void Function()? onDelete,
  void Function()? onEdit, //todo
}) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final result = await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(position, position),
      Offset.zero & overlay.size,
    ),
    elevation: 0,
    popUpAnimationStyle: AnimationStyle(
      duration: Duration(milliseconds: 150),
    ),
    constraints: BoxConstraints(
      maxWidth: isExpanded ? 100 : 40,
      maxHeight: 120,
    ),
    color: GColors.windowColor.shade100,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    items: [
      PopupMenuItem(
        onTap: onEdit,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'edit',
        child: isExpanded
            ? expandedBuild(
                icon: Icons.edit_note_rounded,
                text: 'Edit',
              )
            : shrunkBuild(icon: Icons.edit_note_rounded),
      ),
      PopupMenuItem(
        onTap: onDelete,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'delete',
        child: isExpanded
            ? expandedBuild(
                icon: Icons.delete_sweep_rounded,
                text: 'Delete',
              )
            : shrunkBuild(icon: Icons.delete_sweep_rounded),
      ),
    ],
  );

  return result;
}

Widget shrunkBuild({
  required IconData icon,
}) {
  return Icon(
    icon,
    size: 24,
    color: GColors.windowColor.shade600,
  );
}

Widget expandedBuild({
  required IconData icon,
  required String text,
}) {
  return Row(
    spacing: 5,
    children: [
      Icon(
        icon,
        size: 24,
        color: GColors.windowColor.shade600,
      ),
      Text(
        text,
        style: TextStyle(
          color: GColors.windowColor.shade600,
        ),
      ),
    ],
  );
}
