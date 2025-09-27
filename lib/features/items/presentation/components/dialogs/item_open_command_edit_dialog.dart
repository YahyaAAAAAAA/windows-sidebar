import 'package:flutter/material.dart';
import 'package:windows_widgets/core/utils/enums/app_item_open_command_type.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_radio.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/dialogs/confirmation_dialog.dart';

class ItemOpenCommandEditDialog extends StatelessWidget {
  final String commandType;
  final void Function()? onSavePressed;
  final void Function()? onCancelPressed;
  final void Function(String?)? onExplorerSelected;
  final void Function(String?)? onStartSelected;

  const ItemOpenCommandEditDialog({
    super.key,
    required this.commandType,
    this.onExplorerSelected,
    this.onStartSelected,
    this.onSavePressed,
    this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      onSavePressed: onSavePressed,
      onCancelPressed: onCancelPressed,
      title: 'Change Command:',
      contentChildren: [
        GestureDetector(
          onTap:
              () => onExplorerSelected?.call(
                AppItemOpenCommandType.explorer.name,
              ),
          child: Padding(
            padding: kPadding.medium.pHori,
            child: Row(
              spacing: 15,
              children: [
                AppRadio(
                  value: commandType,
                  groupValue: AppItemOpenCommandType.explorer.name,
                  onChanged:
                      (value) => onExplorerSelected?.call(
                        AppItemOpenCommandType.explorer.name,
                      ),
                ),
                const BodySmallText('Explorer'),
              ],
            ),
          ),
        ),

        GestureDetector(
          onTap: () => onStartSelected?.call(AppItemOpenCommandType.start.name),
          child: Padding(
            padding: kPadding.medium.pHori,
            child: Row(
              spacing: 15,
              children: [
                AppRadio(
                  value: commandType,
                  groupValue: AppItemOpenCommandType.start.name,
                  onChanged:
                      (value) => onStartSelected?.call(
                        AppItemOpenCommandType.start.name,
                      ),
                ),
                const BodySmallText('Start'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
