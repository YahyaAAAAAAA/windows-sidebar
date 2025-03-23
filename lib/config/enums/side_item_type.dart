import 'package:flutter/material.dart';

enum SideItemType {
  folder,
  file,
  url,
  none,
}

extension SideItemTypeExtension on SideItemType {
  IconData get icon {
    switch (this) {
      case SideItemType.folder:
        return Icons.folder;
      case SideItemType.file:
        return Icons.insert_drive_file;
      case SideItemType.url:
        return Icons.link;
      default:
        return Icons.help_outline;
    }
  }
}
