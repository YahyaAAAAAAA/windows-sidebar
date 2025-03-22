import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/config/enums/open_item_command_type.dart';
import 'package:flutter/foundation.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';
import 'package:windows_widgets/config/native_plugins/file_icon_plugin.dart';
import 'package:windows_widgets/config/native_plugins/url_icon_plugin.dart';
import 'package:windows_widgets/config/utils/generate.dart';
import 'package:windows_widgets/config/utils/transition_animation.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_file.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_folder.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_url.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/dialogs/pick_url_dialog.dart';

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

  //pick a url through dialog (a string)
  static Future<SideUrl?> pickUrl({
    required BuildContext context,
    required TextEditingController controller,
  }) async {
    //set init name
    final int id = Generate.generateUniqueId();
    String? url;
    String? errorText;

    //open dialog
    await context.dialog(
      barrierDismissible: false,
      transitionBuilder: TransitionAnimations.slideFromBottom,
      pageBuilder: (context, _, __) => StatefulBuilder(
        builder: (context, setState) => PickUrlDialog(
          controller: controller,
          errorText: errorText,
          // labelText: '${item.type.name.capitalize()} Name',
          hintText: 'Enter URL',
          onCancelPressed: () {
            controller.clear();
            context.pop();
          },
          onSavePressed: () {
            if (controller.text.isEmpty) {
              errorText = 'Please enter a URL';
              setState(() {});
              return;
            }

            url = controller.text;
            context.pop();
          },
        ),
      ),
    );

    //if name empty/user canceled do nothing
    if (controller.text.isEmpty) return null;

    if (url == null) return null;

    //update item, clear controller
    controller.clear();

    final cleanUrl =
        url!.getWebsiteName().removeExtension().removeSubdomain().capitalize();

    return SideUrl(
      id: id,
      path: url!,
      name: cleanUrl.isEmpty ? 'New Url' : cleanUrl,
      command: SideItemOpenCommandType.start.name,
      icon: await UrlIconPlugin.fetchFavicon(url!),
    );
  }
}
