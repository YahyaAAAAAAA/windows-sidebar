import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

enum AppItemType { folder, file, url, none }

extension AppItemTypeExtension on AppItemType {
  IconData get icon {
    switch (this) {
      case AppItemType.folder:
        return FluentIcons.folder_24_regular;
      case AppItemType.file:
        return FluentIcons.document_24_regular;
      case AppItemType.url:
        return FluentIcons.link_24_regular;
      default:
        return FluentIcons.error_circle_20_regular;
    }
  }
}
