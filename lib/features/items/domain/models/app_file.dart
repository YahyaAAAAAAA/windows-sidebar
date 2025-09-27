import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';
import 'package:windows_widgets/core/utils/enums/app_item_type.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';

class AppFile extends AppItem {
  final Uint8List? icon;

  const AppFile({
    required super.id,
    required super.command,
    required super.path,
    required super.name,
    required this.icon,
    super.type = AppItemType.file,
    super.isHovered,
    super.hasFocus,
  });

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'icon': icon};
  }

  @override
  AppFile copyWith({
    int? id,
    String? path,
    String? name,
    String? command,
    AppItemType? type,
    Uint8List? icon,
    bool? isHovered,
    bool? hasFocus,
  }) {
    return AppFile(
      id: id ?? this.id,
      path: path ?? this.path,
      name: name ?? this.name,
      command: command ?? this.command,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      isHovered: isHovered ?? this.isHovered,
      hasFocus: hasFocus ?? this.hasFocus,
    );
  }

  @override
  Future<bool> exists(BuildContext context) async {
    if (!File(path).existsSync()) {
      if (!context.mounted) return false;
      context.showSnackBar('${type.name.capitalize()} doesn\'t exist in directory');
      return false;
    }

    return true;
  }

  Future<void> openLocation(BuildContext context) async {
    if (await exists(context)) {
      await Process.run('explorer', ['/select,', path]);
    }
  }
}
