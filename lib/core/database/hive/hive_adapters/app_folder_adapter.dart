import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/items/domain/models/app_folder.dart';

class AppFolderAdapter extends TypeAdapter<AppFolder> {
  @override
  final int typeId = 0;

  @override
  AppFolder read(BinaryReader reader) {
    final id = reader.read();
    final path = reader.read();
    final name = reader.read();
    final command = reader.read();

    return AppFolder(id: id, path: path, name: name, command: command);
  }

  @override
  void write(BinaryWriter writer, AppFolder obj) {
    writer.write(obj.id);
    writer.write(obj.path);
    writer.write(obj.name);
    writer.write(obj.command);
  }
}
