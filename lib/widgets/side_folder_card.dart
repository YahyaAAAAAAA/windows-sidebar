import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/picker.dart';
import 'package:windows_widgets/models/side_folder.dart';

class SideFolderCard extends StatelessWidget {
  final SideFolder folder;

  const SideFolderCard({
    super.key,
    required this.folder,
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
            Picker.openFolder(folder.path, context);
          },
          icon: Icon(
            Icons.folder,
            color: GColors.windowColor.shade100,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Tooltip(
            message: folder.name,
            verticalOffset: -40,
            decoration: BoxDecoration(
              color: GColors.windowColor.shade600,
              borderRadius: BorderRadius.circular(kOutterRadius),
            ),
            textStyle: TextStyle(
              color: GColors.windowColor.shade100,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            child: Text(
              folder.name,
              style: TextStyle(
                color: GColors.windowColor.shade100,
                fontWeight: FontWeight.w600,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
