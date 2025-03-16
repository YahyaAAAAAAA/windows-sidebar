import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:windows_widgets/config/enums/side_item_type.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';

class SideFile extends SideItem {
  late final Uint8List? icon;
  double? scale;

  SideFile({
    super.id,
    super.type = SideItemType.file,
    required super.command,
    required super.path,
    required super.name,
    required this.icon,
    this.scale = 1.7,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': SideItemType.file.name,
      'command': command,
      'path': path,
      'name': name,
      'icon': icon,
    };
  }

  @override
  Future<bool> exists(BuildContext context) async {
    if (!File(path).existsSync()) {
      if (!context.mounted) return false;
      context.showSnackBar(
          '${type.name.capitalize()} doesn\'t exist in directory');
      return false;
    }

    return true;
  }
}
