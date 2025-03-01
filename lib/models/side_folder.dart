import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/custom_icons.dart';
import 'package:windows_widgets/models/side_item.dart';

class SideFolder extends SideItem {
  //local icon no need to store
  IconData? icon;

  SideFolder({
    super.id,
    required super.path,
    required super.name,
    this.icon = Custom.folder_fill,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'folder',
      'path': path,
      'name': name,
      //Unit8List for files only
      'icon': null,
    };
  }
}
