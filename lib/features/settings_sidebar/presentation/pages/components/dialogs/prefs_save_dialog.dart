import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/widgets/dialog_button.dart';

class PrefsSaveDialog extends StatelessWidget {
  final void Function()? onSavePressed;

  const PrefsSaveDialog({
    super.key,
    this.onSavePressed,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Preferences not saved\nare you sure?',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      contentPadding: EdgeInsets.all(0),
      actionsPadding: EdgeInsets.all(10),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        DialogButton(
          text: 'Save',
          onPressed: onSavePressed,
        ),
        DialogButton(
          text: 'Don\'t Save',
          isFilled: true,
          onPressed: () {
            context.pop();
            context.pop();
          },
        ),
      ],
    );
  }
}
