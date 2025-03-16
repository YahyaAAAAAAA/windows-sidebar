import 'dart:io';

import 'package:flutter/material.dart';
import 'package:windows_widgets/config/enums/side_item_type.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';

class SideFolder extends SideItem {
  //local icon no need to store
  IconData? localIcon;

  SideFolder({
    super.id,
    required super.path,
    required super.name,
    required super.command,
    super.type = SideItemType.folder,
    this.localIcon = Custom.folder_fill,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': SideItemType.folder.name,
      'command': command,
      'path': path,
      'name': name,
      //Unit8List for files only
      'icon': null,
    };
  }

  @override
  Future<bool> exists(BuildContext context) async {
    if (!Directory(path).existsSync()) {
      if (!context.mounted) return false;
      context.showSnackBar(
          '${type.name.capitalize()} doesn\'t exist in directory');
      return false;
    }

    return true;
  }
}
