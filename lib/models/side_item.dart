abstract class SideItem {
  late final int? id;
  late final String path;
  late final String name;

  SideItem({
    this.id,
    required this.path,
    required this.name,
  });

  Map<String, dynamic> toMap();
}
