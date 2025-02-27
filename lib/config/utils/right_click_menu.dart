import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

Future<void> showContextMenu(BuildContext context, Offset position) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  final result = await showMenu(
    context: context,
    position: RelativeRect.fromRect(
      Rect.fromPoints(position, position),
      Offset.zero & overlay.size,
    ),
    constraints: BoxConstraints(
      maxWidth: 40,
      maxHeight: 80,
    ),
    color: GColors.windowColor.shade100,
    items: [
      PopupMenuItem(
        padding: EdgeInsets.symmetric(horizontal: 12),
        value: 'copy',
        child: Icon(
          Icons.delete,
          size: 20,
          color: GColors.windowColor.shade600,
        ),
      ),
      PopupMenuItem(
        value: 'paste',
        child: Icon(
          Icons.edit,
          size: 15,
          color: GColors.windowColor.shade600,
        ),
      ),
    ],
  );

  if (result != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected: $result')),
    );
  }
}
