import 'package:flutter/material.dart';
import 'package:windows_widgets/config/enums/open_item_command_type.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/widgets/dialog_button.dart';

class ChangeItemOpenCommandDialog extends StatelessWidget {
  final String commandType;
  final void Function()? onSavePressed;
  final void Function()? onCancelPressed;
  final void Function(String?)? onExplorerSelected;
  final void Function(String?)? onStartSelected;

  const ChangeItemOpenCommandDialog({
    super.key,
    required this.commandType,
    this.onExplorerSelected,
    this.onStartSelected,
    this.onSavePressed,
    this.onCancelPressed,
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
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'Change Command',
                  style:
                      Theme.of(context).dialogTheme.contentTextStyle?.copyWith(
                            //for some reason this is a must 🤔
                            fontFamily: 'Nova',
                          ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  'Explorer',
                  style:
                      Theme.of(context).dialogTheme.contentTextStyle?.copyWith(
                            fontFamily: 'Nova',
                          ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Radio(
                    value: commandType,
                    groupValue: SideItemOpenCommandType.explorer.name,
                    onChanged: onExplorerSelected,
                  ),
                ),
                Text(
                  'Start',
                  style:
                      Theme.of(context).dialogTheme.contentTextStyle?.copyWith(
                            fontFamily: 'Nova',
                          ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Radio(
                    value: commandType,
                    groupValue: SideItemOpenCommandType.start.name,
                    onChanged: onStartSelected,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(0),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        DialogButton(
          text: 'Save',
          onPressed: onSavePressed,
        ),
        DialogButton(
          text: 'Cancel',
          onPressed: onCancelPressed,
          isFilled: true,
        ),
      ],
    );
  }
}
