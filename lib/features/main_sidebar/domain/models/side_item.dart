import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windows_widgets/config/enums/open_item_command_type.dart';
import 'package:windows_widgets/config/enums/side_item_type.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';

abstract class SideItem {
  late final int? id;
  late final SideItemType type;
  late final String path;
  late String name;
  late String command;

  SideItem({
    this.id,
    required this.path,
    required this.name,
    required this.type,
    required this.command,
  });

  Future<bool> exists(BuildContext context);

  Map<String, dynamic> toMap();

  void open(BuildContext context) async {
    //item doesn't exist
    if (path.isEmpty) {
      context.showSnackBar('Item doesn\'t exist');
      return;
    }
    //open file
    if (command == SideItemOpenCommandType.explorer.name) {
      explorer(context);
    }
    if (command == SideItemOpenCommandType.start.name) {
      start(context);
    }
  }

  void explorer(BuildContext context) async {
    try {
      bool itemExists = await exists(context);
      if (!itemExists) return;

      await Process.run(
        SideItemOpenCommandType.explorer.name,
        [path],
        runInShell: true,
      );
    } catch (e) {
      if (!context.mounted) return;

      context.showSnackBar('Error opening $name');
      return;
    }
  }

  void start(BuildContext context) async {
    try {
      bool itemExists = await exists(context);
      if (!itemExists) return;

      await Process.start(
        path,
        [],
        workingDirectory: path.cutFileName(),
        runInShell: true,
      ).then(
        (value) async {
          //usually when trying to open a folder with "start" command
          int exitCode = await value.exitCode;
          if (exitCode != 0) {
            if (!context.mounted) return;

            context.showSnackBar('Failed to open $name');
          }
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      context.showSnackBar('Error opening $name');
      return;
    }
  }
}
