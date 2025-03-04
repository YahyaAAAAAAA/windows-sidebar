import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';

class SideFileAdapter extends TypeAdapter<SideFile> {
  @override
  final int typeId = 1;

  @override
  SideFile read(BinaryReader reader) {
    final id = reader.read();
    final path = reader.read();
    final name = reader.read();
    final icon = reader.read();

    return SideFile(
      id: id,
      path: path,
      name: name,
      icon: icon,
    );
  }

  @override
  void write(BinaryWriter writer, SideFile obj) {
    writer.write(obj.id);
    writer.write(obj.path);
    writer.write(obj.name);
    writer.write(obj.icon);
  }
}
