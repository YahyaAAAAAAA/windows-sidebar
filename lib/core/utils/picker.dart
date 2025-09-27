import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';
import 'package:windows_widgets/core/utils/enums/app_item_open_command_type.dart';
import 'package:windows_widgets/core/utils/native_plugins/file_icon_plugin.dart';
import 'package:windows_widgets/core/utils/native_plugins/url_icon_plugin.dart';
import 'package:windows_widgets/core/utils/transition_animation.dart';
import 'package:windows_widgets/core/utils/unique.dart';
import 'package:windows_widgets/features/items/domain/models/app_file.dart';
import 'package:windows_widgets/features/items/domain/models/app_folder.dart';
import 'package:windows_widgets/features/items/domain/models/app_url.dart';
import 'package:windows_widgets/features/items/presentation/components/dialogs/url_pick_dialog.dart';

class Picker {
  static Future<AppFolder?> pickFolder() async {
    String? folderPath = await FilePicker.platform.getDirectoryPath();

    if (folderPath != null) {
      final String folderName = folderPath.split(Platform.pathSeparator).last;
      final int id = Unique.idHive();

      return AppFolder(
        id: id,
        path: folderPath,
        name: folderName.isEmpty ? 'New Folder' : folderName,
        command: AppItemOpenCommandType.explorer.name,
      );
    }

    return null;
  }

  static Future<AppFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      final String path = result.files.single.path ?? '';
      final String name = result.files.single.name.removeExtension();
      final Uint8List? icon = await FileIconPlugin.getFileIcon(path);
      final int id = Unique.idHive();

      return AppFile(
        id: id,
        path: path,
        name: name.isEmpty ? 'New File' : name,
        icon: icon,
        command: AppItemOpenCommandType.explorer.name,
      );
    }
    return null;
  }

  //pick a url through dialog (a string)
  static Future<AppUrl?> pickUrl({required BuildContext context, required TextEditingController controller}) async {
    //set init name
    final int id = Unique.idHive();
    String? url;
    String? errorText;

    //open dialog
    await context.dialog(
      barrierDismissible: false,
      transitionBuilder: TransitionAnimations.slideFromBottom,
      pageBuilder: (context, _, _) => StatefulBuilder(
        builder: (context, setState) => UrlPickDialog(
          controller: controller,
          errorText: errorText,
          // labelText: '${item.type.name.capitalize()} Name',
          hintText: 'Enter URL',
          onCancelPressed: () {
            controller.clear();
            context.pop();
          },
          onSavePressed: () {
            if (controller.text.trim().isEmpty) {
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

    final cleanUrl = url!.getWebsiteName().removeExtension().removeSubdomain().capitalize();

    return AppUrl(
      id: id,
      path: url!,
      name: cleanUrl.isEmpty ? 'New Url' : cleanUrl,
      command: AppItemOpenCommandType.start.name,
      icon: await UrlIconPlugin.fetchFavicon(url!),
    );
  }
}
