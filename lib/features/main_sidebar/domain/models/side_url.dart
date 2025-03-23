import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:windows_widgets/config/enums/side_item_type.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';

class SideUrl extends SideItem {
  late final Uint8List? icon;
  double? scale;

  SideUrl({
    super.id,
    super.type = SideItemType.url,
    //this is treated as url
    required super.path,
    required super.name,
    required super.command,
    required this.icon,
    this.scale = 1.7,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': SideItemType.url.name,
      'command': command,
      'path': path,
      'name': name,
      'icon': icon,
    };
  }

  @override
  Future<bool> exists(BuildContext context) async {
    try {
      final request = await HttpClient().headUrl(Uri.parse(path));
      final response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        return true;
      } else {
        if (!context.mounted) return false;
        context.showSnackBar('${type.name.capitalize()} is not reachable');
        return false;
      }
    } catch (e) {
      if (!context.mounted) return false;
      context.showSnackBar('Error checking ${type.name.capitalize()}');
      return false;
    }
  }

  @override
  void start(BuildContext context) async {
    try {
      bool itemExists = await exists(context);
      if (!itemExists) return;

      await Process.start(
        'cmd',
        [
          '/c',
          'start',
          //empty string to avoid title issues
          '',
          path
        ],
        runInShell: true,
      ).then(
        (value) async {
          //? maybe remove later
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
