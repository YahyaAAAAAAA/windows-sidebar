import 'package:windows_widgets/config/enums/side_item_type.dart';

abstract class SideItem {
  late final int? id;
  late final SideItemType type;
  late final String path;
  late String name;
  late String command;

  SideItem({
    this.id,
    required this.path,
    required this.name,
    required this.type,
    required this.command,
  });

  Map<String, dynamic> toMap();
}
