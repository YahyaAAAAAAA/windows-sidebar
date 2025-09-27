import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/dialogs/confirmation_dialog.dart';

class ItemNameEditDialog extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onSavePressed;
  final void Function()? onCancelPressed;
  final String? labelText;
  final String? hintText;
  final String? errorText;

  const ItemNameEditDialog({
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
    return ConfirmationDialog(
      onSavePressed: onSavePressed,
      onCancelPressed: onCancelPressed,
      title: 'Folder Name:',
      bottomSpacing: false,
      contentChildren: [
        Padding(
          padding: 20.pHori,
          child: AppContainer(
            padding: 0.pAll,
            borderColor:
                errorText != null
                    ? context.theme.inputDecorationTheme.errorStyle?.color
                    : context.theme.dividerColor,
            child: TextField(
              controller: controller,
              style: context.textTheme.bodyMedium,
              decoration: InputDecoration(
                error: errorText == null ? null : 0.width,
                hintText: hintText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
