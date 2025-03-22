import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_url.dart';

class SideUrlAdapter extends TypeAdapter<SideUrl> {
  @override
  final int typeId = 3;

  @override
  SideUrl read(BinaryReader reader) {
    final id = reader.read();
    final path = reader.read();
    final name = reader.read();
    final command = reader.read();
    final icon = reader.read();

    return SideUrl(
      id: id,
      path: path,
      name: name,
      command: command,
      icon: icon,
    );
  }

  @override
  void write(BinaryWriter writer, SideUrl obj) {
    writer.write(obj.id);
    writer.write(obj.path);
    writer.write(obj.name);
    writer.write(obj.command);
    writer.write(obj.icon);
  }
}
