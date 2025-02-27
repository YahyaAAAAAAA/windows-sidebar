import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/models/side_file.dart';

class SideFileCard extends StatelessWidget {
  final SideFile file;

  const SideFileCard({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          style: ButtonStyle(
            backgroundColor:
                WidgetStatePropertyAll(GColors.windowColor.shade600),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kOutterRadius),
              ),
            ),
          ),
          onPressed: () {
            Picker.openFolder(file.path, context);
          },
          icon: Transform.scale(
            scale: 1.7,
            child: Image.memory(
              file.icon!,
              width: 16,
              height: 16,
            ),
          ),
        ),
        SizedBox(width: 10),
        Text(
          file.name,
          style: TextStyle(
            color: GColors.windowColor.shade100,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
