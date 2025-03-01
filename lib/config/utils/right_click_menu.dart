import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';

Future<String?> showContextMenu(
  BuildContext context,
  Offset position, {
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
    popUpAnimationStyle: AnimationStyle(
      duration: Duration(milliseconds: 150),
    ),
    constraints: BoxConstraints(
      maxWidth: 40,
      maxHeight: 120,
    ),
    color: GColors.windowColor.shade100,
    items: [
      PopupMenuItem(
        onTap: onDelete,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'copy',
        child: Icon(
          Icons.clear,
          size: 20,
          color: GColors.windowColor.shade600,
        ),
      ),
      PopupMenuItem(
        onTap: onEdit,
        padding: EdgeInsets.symmetric(horizontal: 10),
        value: 'paste',
        child: Icon(
          Icons.edit,
          size: 20,
          color: GColors.windowColor.shade600,
        ),
      ),
    ],
  );

  return result;
}
