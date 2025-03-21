import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/widgets/dialog_button.dart';

class PickUrlDialog extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onSavePressed;
  final void Function()? onCancelPressed;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  const PickUrlDialog({
    super.key,
    required this.controller,
    this.onSavePressed,
    this.onCancelPressed,
    this.labelText,
    this.hintText,
    this.errorText,
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
          spacing: 5,
          children: [
            Row(
              children: [
                Text(
                  'URL:',
                ),
              ],
            ),
            SizedBox(
              width: 150,
              height: errorText == null ? 40 : 60,
              child: TextField(
                controller: controller,
                style: Theme.of(context).textTheme.labelSmall,
                decoration: InputDecoration(
                  errorText: errorText,
                  hintText: hintText,
                ),
              ),
            ),
          ],
        ),
      ),
      actionsPadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(0),
      contentTextStyle: Theme.of(context).dialogTheme.contentTextStyle,
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
