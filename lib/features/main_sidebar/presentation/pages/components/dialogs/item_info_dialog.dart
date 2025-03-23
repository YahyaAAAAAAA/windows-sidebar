import 'package:flutter/material.dart';
import 'package:windows_widgets/config/enums/side_item_type.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/string_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/widgets/dialog_button.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/info_dialog_row.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';

class ItemInfoDialog extends StatelessWidget {
  final SideItem item;

  const ItemInfoDialog({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kOuterRadius),
            topRight: Radius.circular(kOuterRadius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Item Info: ',
                  style:
                      Theme.of(context).dialogTheme.contentTextStyle?.copyWith(
                            fontFamily: 'Nova',
                          ),
                ),
                Tooltip(
                  message: 'shift+mouse wheel to scroll texts',
                  textAlign: TextAlign.center,
                  child: Icon(
                    Icons.info_outline_rounded,
                    size: 15,
                    color:
                        Theme.of(context).dialogTheme.contentTextStyle?.color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            InfoDialogRow(
              icon: item.type.icon,
              title: 'Type: ',
              subTitle: item.type.name.capitalize(),
            ),
            InfoDialogRow(
              icon: Icons.terminal_rounded,
              title: 'Command: ',
              subTitle: item.command.capitalize(),
            ),
            SideDivider(isExpanded: true),
            InfoDialogRow(
              icon: Icons.text_fields_rounded,
              title: 'Name: ',
              subTitle: item.name,
            ),
            InfoDialogRow(
              icon: Icons.roundabout_right_rounded,
              title: item.type == SideItemType.url ? 'Url :' : 'Path: ',
              subTitle: item.path,
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(0),
      contentTextStyle: Theme.of(context).dialogTheme.contentTextStyle,
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        DialogButton(
          text: 'Back',
          onPressed: () => context.pop(),
          isFilled: true,
        ),
      ],
    );
  }
}
