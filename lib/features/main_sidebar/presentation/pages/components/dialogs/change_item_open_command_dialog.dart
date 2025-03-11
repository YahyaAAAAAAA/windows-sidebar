import 'package:flutter/material.dart';
import 'package:windows_widgets/config/enums/open_item_command_type.dart';
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
      content: Row(
        children: [
          Text(
            'Explorer',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Radio(
            value: commandType,
            groupValue: SideItemOpenCommandType.explorer.name,
            onChanged: onExplorerSelected,
          ),
          Text(
            'Start',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Radio(
            value: commandType,
            groupValue: SideItemOpenCommandType.start.name,
            onChanged: onStartSelected,
          ),
        ],
      ),
      actionsPadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(10),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        DialogButton(
          text: 'Save',
          onPressed: onSavePressed,
        ),
        DialogButton(
          text: 'Cancel',
          onPressed: onCancelPressed,
        ),
      ],
    );
  }
}
