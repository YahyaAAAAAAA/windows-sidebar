import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/widgets/dialog_button.dart';

class ChangeItemNameDialog extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onSavePressed;
  final void Function()? onCancelPressed;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  const ChangeItemNameDialog({
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
      content: SizedBox(
        width: 150,
        height: errorText == null ? 40 : 60,
        child: TextField(
          controller: controller,
          style: Theme.of(context).textTheme.labelSmall,
          decoration: InputDecoration(
            errorText: errorText,
            labelText: labelText,
            hintText: hintText,
          ),
        ),
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
