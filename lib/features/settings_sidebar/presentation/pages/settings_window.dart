import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/widgets/app_scaffold.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_button.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/cubits/prefs/prefs_cubit.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/components/blur_row.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/components/resize_row.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/components/opacity_row.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/components/theme_row.dart';

class SettingsWindow extends StatefulWidget {
  const SettingsWindow({
    super.key,
  });

  @override
  State<SettingsWindow> createState() => _SettingsWindowState();
}

class _SettingsWindowState extends State<SettingsWindow>
    with TickerProviderStateMixin, WindowListener, WindowAnimationUtilsMixin {
  late final PrefsCubit prefsCubit;
  double windowHeight = 0;

  @override
  void initState() {
    super.initState();

    prefsCubit = context.read<PrefsCubit>();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        windowHeight = (await windowManager.getSize()).height;

        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          SideButton(
            icon: Icons.arrow_back_ios_new_rounded,
            text: 'Sidebar Settings',
            onPressed: () => context.pop(),
          ),

          SideDivider(isExpanded: true),

          //resize
          ResizeRow(
            windowHeight: windowHeight,
            onUpPressed: () => setState(() => windowHeight += 10),
            onDownPressed: () => setState(() => windowHeight -= 10),
            onDonePressed: () async {
              await animateSizeTo(
                  Size(kWindowWidth, windowHeight.ceilToDouble()));
              prefsCubit.prefs!.windowHeight = windowHeight.ceilToDouble();
            },
          ),

          SizedBox(height: 10),

          //opacity slider
          OpacityRow(
            sliderValue: prefsCubit.prefs!.backgroundOpacity,
            onChanged: (value) {
              prefsCubit.prefs!.backgroundOpacity = value;
              prefsCubit.setOpacity(prefsCubit.prefs!);
              setState(() {});
            },
          ),

          SizedBox(height: 10),

          //blur, solid radios
          BlurRow(
            blurValue: prefsCubit.prefs!.isBlurred,
            borderValue: prefsCubit.prefs!.hasBorder,
            onBlurChanged: (value) async {
              prefsCubit.prefs!.isBlurred = value!;

              if (value) {
                await WindowUtils.blur();
              } else {
                await WindowUtils.transparent();
              }

              setState(() {});
            },
            onBorderChanged: (value) async {
              prefsCubit.prefs!.hasBorder = value!;

              prefsCubit.setBorder(prefsCubit.prefs!);
              setState(() {});
            },
          ),

          SizedBox(height: 10),

          //sidebar theme
          ThemeRow(
            selectedTheme: prefsCubit.prefs!.selectedTheme,
            onLightSelected: (value) {
              prefsCubit.prefs!.selectedTheme = 0;
              prefsCubit.setTheme(prefsCubit.prefs!);
              setState(() {});
            },
            onDarkSelected: (value) {
              prefsCubit.prefs!.selectedTheme = 1;
              prefsCubit.setTheme(prefsCubit.prefs!);
              setState(() {});
            },
            onDeviceSelected: (value) {
              prefsCubit.prefs!.selectedTheme = 2;
              prefsCubit.setTheme(prefsCubit.prefs!);
              setState(() {});
            },
          ),

          Spacer(),

          SideDivider(isExpanded: true),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Apply Settings',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              IconButton(
                onPressed: () async {
                  await prefsCubit.updatePrefs(prefsCubit.prefs!);
                },
                icon: Icon(
                  Icons.check,
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
