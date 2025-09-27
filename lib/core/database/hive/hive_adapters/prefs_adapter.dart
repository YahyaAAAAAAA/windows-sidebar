import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';

class PrefsAdapter extends TypeAdapter<Prefs> {
  @override
  final int typeId = 2;

  @override
  Prefs read(BinaryReader reader) {
    final selectedTheme = reader.readInt();
    final selectedBackgroundEffect = reader.readInt();
    final selectedAccentColor = reader.readInt();
    final backgroundOpacity = reader.readDouble();
    final windowHeight = reader.readDouble();
    final windowWidth = reader.readDouble();
    final hasBorder = reader.readBool();
    final mixBackgroundWithAccent = reader.readBool();
    final useSystemAccentColor = reader.readBool();

    return Prefs(
      backgroundOpacity: backgroundOpacity,
      selectedTheme: selectedTheme,
      selectedBackgroundEffect: selectedBackgroundEffect,
      selectedAccentColor: selectedAccentColor,
      hasBorder: hasBorder,
      windowHeight: windowHeight,
      windowWidth: windowWidth,
      mixBackgroundWithAccent: mixBackgroundWithAccent,
      useSystemAccentColor: useSystemAccentColor,
    );
  }

  @override
  void write(BinaryWriter writer, Prefs obj) {
    writer.writeInt(obj.selectedTheme);
    writer.writeInt(obj.selectedBackgroundEffect);
    writer.writeInt(obj.selectedAccentColor);
    writer.writeDouble(obj.backgroundOpacity);
    writer.writeDouble(obj.windowHeight);
    writer.writeDouble(obj.windowWidth);
    writer.writeBool(obj.hasBorder);
    writer.writeBool(obj.mixBackgroundWithAccent);
    writer.writeBool(obj.useSystemAccentColor);
  }
}
