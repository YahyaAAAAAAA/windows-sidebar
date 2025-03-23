import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';

class InfoDialogRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;

  const InfoDialogRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 5,
      children: [
        Icon(
          icon,
          size: 15,
          color: Theme.of(context).dialogTheme.contentTextStyle?.color,
        ),
        SizedBox(width: 3),
        Text(
          title,
          style: Theme.of(context).dialogTheme.contentTextStyle?.copyWith(
                fontFamily: 'Nova',
              ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(kOuterRadius),
          child: ColoredBox(
            color: Theme.of(context).primaryColor.shade400,
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  child: SelectableText(
                    subTitle,
                    style: Theme.of(context)
                        .dialogTheme
                        .contentTextStyle
                        ?.copyWith(
                          fontFamily: 'Nova',
                        ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
