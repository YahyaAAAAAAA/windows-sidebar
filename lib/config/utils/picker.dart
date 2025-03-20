import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:windows_widgets/config/enums/open_item_command_type.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';
import 'package:windows_widgets/config/native_plugins/file_icon_plugin.dart';
import 'package:windows_widgets/config/utils/generate.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';

class Picker {
  static Future<SideFolder?> pickFolder() async {
    String? folderPath = await FilePicker.platform.getDirectoryPath();

    if (folderPath != null) {
      final String folderName = folderPath.split(Platform.pathSeparator).last;
      final int id = Generate.generateUniqueId();

      return SideFolder(
        id: id,
        path: folderPath,
        name: folderName.isEmpty ? 'New Folder' : folderName,
        command: SideItemOpenCommandType.explorer.name,
      );
    }

    return null;
  }

  static Future<SideFile?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      final String path = result.files.single.path ?? '';
      final String name = result.files.single.name.removeExtension();
      final Uint8List? icon = await FileIconPlugin.getFileIcon(path);
      final int id = Generate.generateUniqueId();

      return SideFile(
        id: id,
        path: path,
        name: name.isEmpty ? 'New File' : name,
        icon: icon,
        command: SideItemOpenCommandType.explorer.name,
      );
    }
    return null;
  }
}
