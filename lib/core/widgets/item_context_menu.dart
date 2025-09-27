import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/packages/context_menu/context_menu_area.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';

Future<void> itemContextMenu(
  BuildContext context,
  Offset position, {
  void Function()? onInfo,
  void Function()? onDelete,
  void Function()? onNameEdit,
  void Function()? onCommandEdit,
  void Function()? onOpenLocation,
}) async => await showContextMenu(
  position,
  context,
  (context) => [
    itemBuild(
      context,
      onTap: () {
        context.pop();
        onInfo?.call();
      },
      icon: FluentIcons.info_24_regular,
      text: 'Info',
    ),
    itemBuild(
      context,
      onTap: () {
        context.pop();
        onNameEdit?.call();
      },
      icon: FluentIcons.code_text_edit_20_regular,
      text: 'Edit Name',
    ),
    itemBuild(
      context,
      onTap: () {
        context.pop();
        onCommandEdit?.call();
      },
      icon: FluentIcons.window_console_20_regular,
      text: 'Edit Command',
    ),
    if (onOpenLocation != null)
      itemBuild(
        context,
        onTap: () {
          context.pop();
          onOpenLocation.call();
        },
        icon: FluentIcons.open_folder_24_regular,
        text: 'Open Location',
      ),

    PopupMenuDivider(height: kPadding.medium.toDouble()),

    itemBuild(
      context,
      onTap: () {
        context.pop();
        onDelete?.call();
      },
      icon: FluentIcons.delete_24_regular,
      text: 'Delete',
    ),
  ],
  kPadding.medium.toDouble(),
  kContextMenu.width,
);

Widget itemBuild(
  BuildContext context, {
  required IconData icon,
  required String text,
  void Function()? onTap,
}) {
  return Padding(
    padding: kPadding.small.pHori,
    child: ListTile(
      onTap: onTap,
      minTileHeight: kContextMenu.height,
      hoverColor: context.theme.hoverColor,
      leading: Icon(icon, size: kIconSize.small, color: context.iconColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadius.outer),
      ),
      title: BodySmallText(
        text,
        config: AppTextConfiguration(
          color: context.theme.colorScheme.onSurface,
        ),
      ),
    ),
  );
}
