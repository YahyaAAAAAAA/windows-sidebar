import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';

Future<String?> showContextMenu(
  BuildContext context,
  Offset position,
  bool isExpanded, {
  void Function()? onDelete,
  void Function()? onNameEdit,
  void Function()? onCommandEdit,
}) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final result = await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(position, position),
      Offset.zero & overlay.size,
    ),
    elevation: 1,
    popUpAnimationStyle: AnimationStyle(
      duration: Duration(milliseconds: 150),
    ),
    constraints: BoxConstraints(
      maxWidth: isExpanded ? 150 : 40,
      maxHeight: 150,
    ),
    color: Theme.of(context).secondaryHeaderColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(kOuterRadius),
    ),
    items: [
      PopupMenuItem(
        onTap: onNameEdit,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'edit',
        child: isExpanded
            ? expandedBuild(
                context,
                icon: Icons.edit_note_rounded,
                text: 'Edit Name',
              )
            : shrunkBuild(icon: Icons.edit_note_rounded),
      ),
      PopupMenuItem(
        onTap: onCommandEdit,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'command',
        child: isExpanded
            ? expandedBuild(
                context,
                icon: Icons.terminal_rounded,
                text: 'Open Command',
              )
            : shrunkBuild(icon: Icons.terminal_rounded),
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
