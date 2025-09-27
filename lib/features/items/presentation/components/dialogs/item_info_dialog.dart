import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:windows_widgets/core/utils/enums/app_item_type.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/dialogs/informaiton_dialog.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';

class ItemInfoDialog extends StatelessWidget {
  final void Function()? onCancelPressed;
  final AppItem item;

  const ItemInfoDialog({super.key, required this.item, this.onCancelPressed});

  @override
  Widget build(BuildContext context) {
    return InformationDialog(
      onCancelPressed: onCancelPressed,
      title: 'Item Details:',
      topbarMainAxisAlignment: MainAxisAlignment.spaceBetween,
      contentCrossAxisAlignment: CrossAxisAlignment.start,
      topbarChildren: [
        Tooltip(
          message: 'shift+mouse wheel to scroll texts',
          textAlign: TextAlign.center,
          child: Icon(Icons.info_outline_rounded, size: kIconSize.tiny),
        ),
      ],
      contentChildren: [
        buildInformationRow(
          context,
          icon: item.type.icon,
          title: 'Type: ',
          subTitle: item.type.name.capitalize(),
        ),
        buildInformationRow(
          context,
          icon: FluentIcons.window_console_20_regular,
          title: 'Command: ',
          subTitle: item.command.capitalize(),
        ),
        buildInformationRow(
          context,
          icon: FluentIcons.text_32_regular,
          title: 'Name: ',
          subTitle: item.name,
        ),
        buildInformationRow(
          context,
          icon: FluentIcons.document_folder_24_regular,
          title: item.type == AppItemType.url ? 'Url :' : 'Path: ',
          subTitle: item.path,
        ),
      ],
    );
  }

  Widget buildInformationRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subTitle,
  }) {
    return Padding(
      padding: kPadding.medium.pHori,
      child: Row(
        spacing: kGap.small,
        children: [
          Icon(icon, size: kIconSize.tiny),
          BodyMediumText(title),
          AppContainer(
            padding: kPadding.medium.pAll,
            constraints: const BoxConstraints(maxWidth: 350),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(scrollbars: false),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                child: SelectableText(subTitle, maxLines: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
