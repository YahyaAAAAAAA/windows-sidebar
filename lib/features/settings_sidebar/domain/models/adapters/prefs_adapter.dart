import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';

class PrefsAdapter extends TypeAdapter<Prefs> {
  @override
  final int typeId = 2;

  @override
  Prefs read(BinaryReader reader) {
    final backgroundOpacity = reader.readDouble();
    final selectedTheme = reader.readInt();
    final isBlurred = reader.readBool();
    final hasBorder = reader.readBool();
    final windowHeight = reader.readDouble();
    final scaffoldPadding = reader.readDouble();

    return Prefs(
      backgroundOpacity: backgroundOpacity,
      selectedTheme: selectedTheme,
      isBlurred: isBlurred,
      hasBorder: hasBorder,
      windowHeight: windowHeight,
      scaffoldPadding: scaffoldPadding,
    );
  }

  @override
  void write(BinaryWriter writer, Prefs obj) {
    writer.writeDouble(obj.backgroundOpacity);
    writer.writeInt(obj.selectedTheme);
    writer.writeBool(obj.isBlurred);
    writer.writeBool(obj.hasBorder);
    writer.writeDouble(obj.windowHeight);
    writer.writeDouble(obj.scaffoldPadding);
  }
}
