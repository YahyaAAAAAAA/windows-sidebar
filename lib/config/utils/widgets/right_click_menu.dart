import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';

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
    color: Theme.of(context).secondaryHeaderColor,
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
                context,
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
                context,
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
  );
}

Widget expandedBuild(
  BuildContext context, {
  required IconData icon,
  required String text,
}) {
  return Row(
    spacing: 5,
    children: [
      Icon(
        icon,
        size: 24,
      ),
      Text(
        text,
        style: Theme.of(context).textTheme.labelMedium,
      ),
    ],
  );
}
