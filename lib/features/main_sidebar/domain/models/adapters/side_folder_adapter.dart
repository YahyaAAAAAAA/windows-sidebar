import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';

class SideFolderAdapter extends TypeAdapter<SideFolder> {
  @override
  final int typeId = 0;

  @override
  SideFolder read(BinaryReader reader) {
    final id = reader.read();
    final path = reader.read();
    final name = reader.read();
    final command = reader.read();

    return SideFolder(
      id: id,
      path: path,
      name: name,
      command: command,
    );
  }

  @override
  void write(BinaryWriter writer, SideFolder obj) {
    writer.write(obj.id);
    writer.write(obj.path);
    writer.write(obj.name);
    writer.write(obj.command);
  }
}
