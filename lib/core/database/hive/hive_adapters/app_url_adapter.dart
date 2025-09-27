import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/items/domain/models/app_url.dart';

class AppUrlAdapter extends TypeAdapter<AppUrl> {
  @override
  final int typeId = 3;

  @override
  AppUrl read(BinaryReader reader) {
    final id = reader.read();
    final path = reader.read();
    final name = reader.read();
    final command = reader.read();
    final icon = reader.read();

    return AppUrl(id: id, path: path, name: name, command: command, icon: icon);
  }

  @override
  void write(BinaryWriter writer, AppUrl obj) {
    writer.write(obj.id);
    writer.write(obj.path);
    writer.write(obj.name);
    writer.write(obj.command);
    writer.write(obj.icon);
  }
}
