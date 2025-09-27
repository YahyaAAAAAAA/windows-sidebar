import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/items/domain/models/app_file.dart';

class AppFileAdapter extends TypeAdapter<AppFile> {
  @override
  final int typeId = 1;

  @override
  AppFile read(BinaryReader reader) {
    final id = reader.read();
    final path = reader.read();
    final name = reader.read();
    final icon = reader.read();
    final command = reader.read();

    return AppFile(
      id: id,
      path: path,
      name: name,
      icon: icon,
      command: command,
    );
  }

  @override
  void write(BinaryWriter writer, AppFile obj) {
    writer.write(obj.id);
    writer.write(obj.path);
    writer.write(obj.name);
    writer.write(obj.icon);
    writer.write(obj.command);
  }
}
