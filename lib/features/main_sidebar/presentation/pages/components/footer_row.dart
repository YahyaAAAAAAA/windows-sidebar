import 'package:flutter/material.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_button.dart';

class FooterRow extends StatelessWidget {
  final void Function()? onPickFolderPressed;
  final void Function()? onPickFilePressed;
  final bool isExpanded;

  const FooterRow({
    super.key,
    required this.isExpanded,
    this.onPickFolderPressed,
    this.onPickFilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isExpanded
            ? SideButton.imageExpanded(
                imagePath: 'assets/images/folder_add.png',
                text: 'Pick a Folder',
                onPressed: onPickFolderPressed,
                buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      side: WidgetStatePropertyAll(BorderSide.none),
                    ),
              )
            : SideButton.imageShrunk(
                imagePath: 'assets/images/folder_add.png',
                text: 'Pick a Folder',
                onPressed: onPickFolderPressed,
                buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      side: WidgetStatePropertyAll(BorderSide.none),
                    ),
              ),
        SizedBox(height: 2),
        isExpanded
            ? SideButton.imageExpanded(
                imagePath: 'assets/images/file_add.png',
                text: 'Pick a File',
                onPressed: onPickFilePressed,
                buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      side: WidgetStatePropertyAll(BorderSide.none),
                    ),
              )
            : SideButton.imageShrunk(
                imagePath: 'assets/images/file_add.png',
                text: 'Pick a File',
                onPressed: onPickFilePressed,
                buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      side: WidgetStatePropertyAll(BorderSide.none),
                    ),
              ),
      ],
    );
  }
}
