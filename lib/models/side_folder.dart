import 'package:windows_widgets/models/side_item.dart';

class SideFolder extends SideItem {
  SideFolder({
    required super.path,
    required super.name,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'folder',
      'path': path,
      'name': name,
      'icon': null, // No icon for folders
    };
  }
}
