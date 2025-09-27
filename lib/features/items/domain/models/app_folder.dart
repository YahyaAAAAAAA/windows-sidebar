import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';
import 'package:windows_widgets/core/utils/enums/app_item_type.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';

class AppFolder extends AppItem {
  const AppFolder({
    required super.id,
    required super.path,
    required super.name,
    required super.command,
    super.type = AppItemType.folder,
    super.isHovered,
    super.hasFocus,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': AppItemType.folder.name,
      'command': command,
      'path': path,
      'name': name,
      //Unit8List for files only
      'icon': null,
    };
  }

  @override
  AppFolder copyWith({
    int? id,
    String? path,
    String? name,
    String? command,
    AppItemType? type,
    bool? isHovered,
    bool? hasFocus,
  }) {
    return AppFolder(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      command: command ?? this.command,
      isHovered: isHovered ?? this.isHovered,
      hasFocus: hasFocus ?? this.hasFocus,
    );
  }

  @override
  Future<bool> exists(BuildContext context) async {
    if (!Directory(path).existsSync()) {
      if (!context.mounted) return false;
      context.showSnackBar('${type.name.capitalize()} doesn\'t exist in directory');
      return false;
    }

    return true;
  }
}
