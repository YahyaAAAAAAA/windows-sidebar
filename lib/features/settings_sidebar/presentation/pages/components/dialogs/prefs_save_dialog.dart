import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/utils/widgets/dialog_button.dart';

class PrefsSaveDialog extends StatelessWidget {
  const PrefsSaveDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Preferences not saved\nare you sure?',
            style: Theme.of(context).textTheme.labelLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actionsPadding: EdgeInsets.all(5),
      contentPadding: EdgeInsets.all(5),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        DialogButton(
          text: 'Save',
          onPressed: () => context.pop(),
        ),
        DialogButton(
          text: 'Don\'t Save',
          onPressed: () {
            context.pop();
            context.pop();
          },
        ),
      ],
    );
  }
}
