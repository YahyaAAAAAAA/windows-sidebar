abstract class SideItem {
  late final String path;
  late final String name;

  SideItem({
    required this.path,
    required this.name,
  });

  Map<String, dynamic> toMap();
}
