import 'dart:typed_data';
import 'package:windows_widgets/models/side_item.dart';

class SideFile extends SideItem {
  late final Uint8List? icon;

  SideFile({
    super.id,
    required super.path,
    required super.name,
    required this.icon,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'file',
      'path': path,
      'name': name,
      'icon': icon, // Uint8List stored as BLOB
    };
  }
}
