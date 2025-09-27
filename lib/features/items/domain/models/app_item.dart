import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';
import 'package:windows_widgets/core/utils/enums/app_item_open_command_type.dart';
import 'package:windows_widgets/core/utils/enums/app_item_type.dart';

abstract class AppItem {
  final int id;
  final String path;
  final String name;
  final String command;
  final AppItemType type;
  final bool isHovered;
  final bool hasFocus;

  const AppItem({
    required this.id,
    required this.path,
    required this.name,
    required this.command,
    required this.type,
    this.isHovered = false,
    this.hasFocus = false,
  });

  Future<bool> exists(BuildContext context);

  /// For fast logging
  List<Object> get logParams => [name, type.name, path, id];

  AppItem copyWith({
    int? id,
    String? path,
    String? name,
    String? command,
    AppItemType? type,
    bool? isHovered,
    bool? hasFocus,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'path': path, 'name': name, 'command': command, 'type': type.name};
  }

  void open(BuildContext context) async {
    //item doesn't exist
    if (path.isEmpty) {
      context.showSnackBar('Item doesn\'t exist');
      return;
    }
    //open file
    if (command == AppItemOpenCommandType.explorer.name) {
      explorer(context);
    }
    if (command == AppItemOpenCommandType.start.name) {
      start(context);
    }
  }

  void explorer(BuildContext context) async {
    try {
      bool itemExists = await exists(context);
      if (!itemExists) return;

      await Process.run(AppItemOpenCommandType.explorer.name, [path], runInShell: true);
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

      await Process.start(path, [], workingDirectory: path.cutFileName(), runInShell: true).then((value) async {
        //usually when trying to open a folder with "start" command
        int exitCode = await value.exitCode;
        if (exitCode != 0) {
          if (!context.mounted) return;

          context.showSnackBar('Failed to open $name');
        }
      });
    } catch (e) {
      if (!context.mounted) return;

      context.showSnackBar('Error opening $name');
      return;
    }
  }
}
