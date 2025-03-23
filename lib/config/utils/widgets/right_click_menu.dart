import 'package:flutter/material.dart';

Future<String?> showContextMenu(
  BuildContext context,
  Offset position,
  bool isExpanded, {
  void Function()? onInfo,
  void Function()? onDelete,
  void Function()? onNameEdit,
  void Function()? onCommandEdit,
  void Function()? onOpenLocation,
}) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final itemHeight = kMinInteractiveDimension - 15;

  final result = await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(position, position),
      Offset.zero & overlay.size,
    ),
    constraints: BoxConstraints(
      maxWidth: isExpanded ? 140 : 40,
    ),
    elevation: Theme.of(context).popupMenuTheme.elevation,
    shape: Theme.of(context).popupMenuTheme.shape,
    items: isExpanded
        ? <PopupMenuEntry<String>>[
            PopupMenuItem(
              onTap: onInfo,
              height: itemHeight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              value: 'info',
              textStyle: Theme.of(context).popupMenuTheme.textStyle,
              child: expandedBuild(
                context,
                icon: Icons.info_outline_rounded,
                text: 'Info',
              ),
            ),
            PopupMenuItem(
              onTap: onNameEdit,
              height: itemHeight,
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
              height: itemHeight,
              padding: EdgeInsets.symmetric(horizontal: 10),
              value: 'command',
              textStyle: Theme.of(context).popupMenuTheme.textStyle,
              child: expandedBuild(
                context,
                icon: Icons.terminal_rounded,
                text: 'Open Command',
              ),
            ),
            if (onOpenLocation != null)
              PopupMenuItem(
                onTap: onOpenLocation,
                height: itemHeight,
                padding: EdgeInsets.symmetric(horizontal: 10),
                value: 'open location',
                textStyle: Theme.of(context).popupMenuTheme.textStyle,
                child: expandedBuild(
                  context,
                  icon: Icons.folder_open_rounded,
                  text: 'Open Location',
                ),
              ),
            PopupMenuDivider(height: 5),
            PopupMenuItem(
              onTap: onDelete,
              padding: EdgeInsets.symmetric(horizontal: 10),
              value: 'delete',
              height: itemHeight,
              textStyle: Theme.of(context).popupMenuTheme.textStyle,
              child: expandedBuild(
                context,
                icon: Icons.delete_sweep_outlined,
                text: 'Delete',
              ),
            ),
          ]
        : <PopupMenuEntry<String>>[
            if (onOpenLocation != null)
              PopupMenuItem(
                onTap: onOpenLocation,
                height: itemHeight,
                padding: EdgeInsets.symmetric(horizontal: 10),
                value: 'open location',
                textStyle: Theme.of(context).popupMenuTheme.textStyle,
                child: shrunkBuild(
                  context,
                  icon: Icons.folder_open_rounded,
                ),
              ),
            PopupMenuItem(
              onTap: onDelete,
              padding: EdgeInsets.symmetric(horizontal: 10),
              value: 'delete',
              height: itemHeight,
              textStyle: Theme.of(context).popupMenuTheme.textStyle,
              child: shrunkBuild(
                context,
                icon: Icons.delete_sweep_outlined,
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
    children: [
      Icon(
        icon,
        size: 20,
        color: Theme.of(context).popupMenuTheme.textStyle?.color,
      ),
      SizedBox(width: 5),
      Text(
        text,
        style: Theme.of(context).popupMenuTheme.textStyle,
      ),
    ],
  );
}

Widget shrunkBuild(
  BuildContext context, {
  required IconData icon,
}) {
  return Icon(
    icon,
    size: 20,
    color: Theme.of(context).popupMenuTheme.textStyle?.color,
  );
}
