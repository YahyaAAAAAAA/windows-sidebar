import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/core/utils/enums/app_item_open_command_type.dart';
import 'package:windows_widgets/core/utils/enums/app_item_type.dart';

class SystemItem {
  final int id;
  final String path;
  final String name;
  final String command;
  final bool isHovered;
  final bool hasFocus;
  final IconData icon;

  const SystemItem({
    required this.id,
    required this.name,
    required this.path,
    required this.command,
    required this.icon,
    this.isHovered = false,
    this.hasFocus = false,
  });

  SystemItem copyWith({
    int? id,
    String? path,
    String? name,
    String? command,
    AppItemType? type,
    IconData? icon,
    bool? isHovered,
    bool? hasFocus,
  }) {
    return SystemItem(
      command: command ?? this.command,
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      isHovered: isHovered ?? this.isHovered,
      hasFocus: hasFocus ?? this.hasFocus,
      icon: icon ?? this.icon,
    );
  }

  void open(BuildContext context) async {
    await Process.start('cmd', ['/c', 'start', '', path], runInShell: true);
  }
}

class AppSystemFilesManager {
  static final List<SystemItem> appSystemFiles = [
    SystemItem(
      id: 1,
      command: AppItemOpenCommandType.start.name,
      name: 'PC',
      path: 'shell:MyComputerFolder',
      icon: FluentIcons.desktop_24_regular,
    ),
    SystemItem(
      id: 2,
      command: AppItemOpenCommandType.start.name,
      name: 'Desktop',
      path: 'shell:Desktop',
      icon: FluentIcons.tv_24_regular,
    ),
    SystemItem(
      id: 3,
      command: AppItemOpenCommandType.start.name,
      name: 'Downloads',
      path: 'shell:Downloads',
      icon: FluentIcons.arrow_download_24_regular,
    ),
    SystemItem(
      id: 4,
      command: AppItemOpenCommandType.start.name,
      name: 'Documents',
      path: 'shell:Personal',
      icon: FluentIcons.document_24_regular,
    ),
    SystemItem(
      id: 5,
      command: AppItemOpenCommandType.start.name,
      name: 'Music',
      path: 'shell:My Music',
      icon: FluentIcons.video_play_pause_24_regular,
    ),
    SystemItem(
      id: 6,
      command: AppItemOpenCommandType.start.name,
      name: 'Pictures',
      path: 'shell:My Pictures',
      icon: FluentIcons.image_24_regular,
    ),
    SystemItem(
      id: 7,
      command: AppItemOpenCommandType.start.name,
      name: 'Videos',
      path: 'shell:My Video',
      icon: FluentIcons.video_24_regular,
    ),
  ];
}
