import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/config/enums/open_item_command_type.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';
import 'package:windows_widgets/config/native_plugins/file_icon_plugin.dart';
import 'package:windows_widgets/config/utils/generate.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';

class Picker {
  static Future<SideFolder?> pickFolder() async {
    String? folderPath = await FilePicker.platform.getDirectoryPath();

    if (folderPath != null) {
      final String folderName = folderPath.split(Platform.pathSeparator).last;
      final int id = Generate.generateUniqueId();

      return SideFolder(
        id: id,
        path: folderPath,
        name: folderName,
        command: SideItemOpenCommandType.explorer.name,
      );
    }

    return null;
  }

  static Future<SideFile?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      final String path = result.files.single.path ?? '';
      final String name = result.files.single.name.removeExtension();
      final Uint8List? icon = await FileIconPlugin.getFileIcon(path);
      final int id = Generate.generateUniqueId();

      return SideFile(
        id: id,
        path: path,
        name: name,
        icon: icon,
        command: SideItemOpenCommandType.explorer.name,
      );
    }
    return null;
  }

  static void openItem(SideItem? item, BuildContext context) async {
    //item doesn't exist
    if (item == null) {
      context.showSnackBar('Item doesn\'t exist');
      return;
    }
    //open file
    if (item.command == SideItemOpenCommandType.explorer.name) {
      explorer(item, context);
    }
    if (item.command == SideItemOpenCommandType.start.name) {
      start(item, context);
    }
  }

  static void explorer(SideItem item, BuildContext context) async {
    try {
      bool exists = await item.exists(context);
      if (!exists) return;

      await Process.run(
        SideItemOpenCommandType.explorer.name,
        [item.path],
        runInShell: true,
      );
    } catch (e) {
      if (!context.mounted) return;

      context.showSnackBar('Error opening ${item.name}');
      return;
    }
  }

  static void start(SideItem item, BuildContext context) async {
    try {
      bool exists = await item.exists(context);
      if (!exists) return;

      await Process.start(
        item.path,
        [],
        workingDirectory: item.path.cutFileName(),
        runInShell: true,
      ).then(
        (value) async {
          //usually when trying to open a folder with "start" command
          int exitCode = await value.exitCode;
          if (exitCode != 0) {
            if (!context.mounted) return;

            context.showSnackBar('Failed to open ${item.name}');
          }
        },
      );
    } catch (e) {
      if (!context.mounted) return;

      context.showSnackBar('Error opening ${item.name}');
      return;
    }
  }
}
