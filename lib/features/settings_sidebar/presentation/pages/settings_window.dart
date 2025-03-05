import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_button.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/components/resize_row.dart';

class SettingsWindow extends StatefulWidget {
  const SettingsWindow({
    super.key,
  });

  @override
  State<SettingsWindow> createState() => _SettingsWindowState();
}

class _SettingsWindowState extends State<SettingsWindow>
    with TickerProviderStateMixin, WindowListener, WindowAnimationUtilsMixin {
  double windowHeight = 0;
  double opacity = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        windowHeight = (await windowManager.getSize()).height;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kOuterRadius),
          bottomLeft: Radius.circular(kOuterRadius),
        ),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                SideButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  text: 'Back',
                  onPressed: () => context.pop(),
                ),
                SideDivider(isExpanded: false),
                //settings
                Expanded(
                    child: ListView(
                  children: [
                    //resize
                    ResizeRow(
                      windowHeight: windowHeight,
                      onUpPressed: () => setState(() => windowHeight += 10),
                      onDownPressed: () => setState(() => windowHeight -= 10),
                      onDonePressed: () async {
                        await animateSizeTo(
                            Size(200, windowHeight.ceilToDouble()));
                      },
                    ),

                    SizedBox(height: 10),

                    //opacity slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SideDivider(
                                isExpanded: true,
                                // color: GColors.windowColor.shade100,
                              ),
                            ),
                            Text(
                              'Sidebar Opacity',
                              style: TextStyle(
                                color: GColors.windowColor.shade100,
                                fontSize: 12,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: SideDivider(
                                isExpanded: true,
                                // color: GColors.windowColor.shade100,
                              ),
                            ),
                          ],
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Slider(
                                value: opacity,
                                max: 1,
                                min: 0,
                                thumbColor: GColors.windowColor.shade100,
                                activeColor: GColors.windowColor.shade100,
                                inactiveColor: GColors.windowColor.shade300,
                                onChanged: (value) {
                                  setState(() {
                                    opacity = value;
                                    GColors.windowColorOpacity = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
