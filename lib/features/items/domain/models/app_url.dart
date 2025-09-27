import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';
import 'package:windows_widgets/core/utils/enums/app_item_type.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';

class AppUrl extends AppItem {
  final Uint8List? icon;

  const AppUrl({
    required super.id,
    required super.path, //this is treated as url
    required super.name,
    required super.command,
    required this.icon,
    super.type = AppItemType.url,
    super.isHovered,
    super.hasFocus,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'id': id, 'type': AppItemType.url.name, 'command': command, 'path': path, 'name': name, 'icon': icon};
  }

  @override
  AppUrl copyWith({
    int? id,
    String? path,
    String? name,
    String? command,
    AppItemType? type,
    Uint8List? icon,
    bool? isHovered,
    bool? hasFocus,
  }) {
    return AppUrl(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      command: command ?? this.command,
      icon: icon ?? this.icon,
      isHovered: isHovered ?? this.isHovered,
      hasFocus: hasFocus ?? this.hasFocus,
    );
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

      await Process.start('cmd', [
        '/c',
        'start',
        //empty string to avoid title issues
        '',
        path,
      ], runInShell: true).then((value) async {
        //? maybe remove later
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
