import 'package:flutter/material.dart';

Future<String?> showContextMenu(
  BuildContext context,
  Offset position,
  bool isExpanded, {
  void Function()? onDelete,
  void Function()? onNameEdit,
  void Function()? onCommandEdit,
}) async {
  if (!isExpanded) return null;

  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final result = await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(position, position),
      Offset.zero & overlay.size,
    ),
    popUpAnimationStyle: AnimationStyle(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    ),
    constraints: BoxConstraints(
      maxWidth: isExpanded ? 150 : 40,
      maxHeight: 150,
    ),
    elevation: Theme.of(context).popupMenuTheme.elevation,
    shape: Theme.of(context).popupMenuTheme.shape,
    items: [
      PopupMenuItem(
        onTap: onNameEdit,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'edit',
        textStyle: Theme.of(context).popupMenuTheme.textStyle,
        child: expandedBuild(
          context,
          icon: Icons.edit_note_rounded,
          text: 'Edit Name',
        ),
      ),
      PopupMenuItem(
        onTap: onCommandEdit,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'command',
        textStyle: Theme.of(context).popupMenuTheme.textStyle,
        child: expandedBuild(
          context,
          icon: Icons.terminal_rounded,
          text: 'Open Command',
        ),
      ),
      PopupMenuItem(
        onTap: onDelete,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'delete',
        textStyle: Theme.of(context).popupMenuTheme.textStyle,
        child: expandedBuild(
          context,
          icon: Icons.delete_sweep_rounded,
          text: 'Delete',
        ),
      ),
    ],
  );

  return result;
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
        size: 20,
        color: Theme.of(context).popupMenuTheme.textStyle?.color,
      ),
      Text(
        text,
        style: Theme.of(context).popupMenuTheme.textStyle,
      ),
    ],
  );
}
