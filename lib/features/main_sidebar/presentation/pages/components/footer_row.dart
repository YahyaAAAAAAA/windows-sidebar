import 'package:flutter/material.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/widgets/expandable.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_button.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';

class FooterRow extends StatelessWidget {
  final void Function()? onPickFolderPressed;
  final void Function()? onPickFilePressed;
  final void Function()? onPickUrlPressed;
  final bool isExpanded;

  const FooterRow({
    super.key,
    required this.isExpanded,
    this.onPickFolderPressed,
    this.onPickFilePressed,
    this.onPickUrlPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expandable(
          isExpanded: isExpanded,
          borderRadius: BorderRadius.circular(kOuterRadius),
          backgroundColor: Colors.transparent,
          clickable: isExpanded ? Clickable.firstChildOnly : Clickable.none,
          firstChild: Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SideDivider(
                    isExpanded: isExpanded,
                    endIndent: !isExpanded ? 80 : 0,
                  ),
                ),
                Text(
                  'More',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          secondChild: isExpanded
              ? SideButton.imageExpanded(
                  imagePath: 'assets/images/url_add.png',
                  text: 'Add a Url',
                  onPressed: onPickUrlPressed,
                  buttonStyle:
                      Theme.of(context).iconButtonTheme.style?.copyWith(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            side: WidgetStatePropertyAll(BorderSide.none),
                          ),
                )
              : SideButton.imageShrunk(
                  imagePath: 'assets/images/url_add.png',
                  text: 'Add a Url',
                  onPressed: onPickUrlPressed,
                  buttonStyle:
                      Theme.of(context).iconButtonTheme.style?.copyWith(
                            backgroundColor:
                                WidgetStatePropertyAll(Colors.transparent),
                            side: WidgetStatePropertyAll(BorderSide.none),
                          ),
                ),
        ),
        isExpanded
            ? SideButton.imageExpanded(
                imagePath: 'assets/images/folder_add.png',
                text: 'Add a Folder',
                onPressed: onPickFolderPressed,
                buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      side: WidgetStatePropertyAll(BorderSide.none),
                    ),
              )
            : SideButton.imageShrunk(
                imagePath: 'assets/images/folder_add.png',
                text: 'Add a Folder',
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
                text: 'Add a File',
                onPressed: onPickFilePressed,
                buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
                      backgroundColor:
                          WidgetStatePropertyAll(Colors.transparent),
                      side: WidgetStatePropertyAll(BorderSide.none),
                    ),
              )
            : SideButton.imageShrunk(
                imagePath: 'assets/images/file_add.png',
                text: 'Add a File',
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
