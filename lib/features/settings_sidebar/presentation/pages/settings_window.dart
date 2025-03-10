import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/identical.dart';
import 'package:windows_widgets/config/utils/widgets/app_scaffold.dart';
import 'package:windows_widgets/config/utils/widgets/global_loading.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_button.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/cubits/prefs/prefs_cubit.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/cubits/prefs/prefs_states.dart';
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
  Prefs? initPrefs;
  double windowHeight = 0;
  bool didUserUpdate = false;

  @override
  void initState() {
    super.initState();

    prefsCubit = context.read<PrefsCubit>();
    initPrefs = prefsCubit.prefs?.copyWith();

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
            onPressed: () async {
              if (!prefsIdentical(prefsCubit.prefs!, initPrefs!)) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text('you sure you want to exit?'),
                  ),
                );
                return;
              }
              context.pop();
            },
          ),

          SideDivider(isExpanded: true),

          //resize
          ResizeRow(
            windowHeight: windowHeight.ceilToDouble(),
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
              prefsCubit.updatePrefs(prefsCubit.prefs!);
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

              prefsCubit.updatePrefs(prefsCubit.prefs!);
              setState(() {});
            },
          ),

          SizedBox(height: 10),

          //sidebar theme
          ThemeRow(
            selectedTheme: prefsCubit.prefs!.selectedTheme,
            onLightSelected: (value) {
              prefsCubit.prefs!.selectedTheme = 0;
              prefsCubit.updatePrefs(prefsCubit.prefs!);
              setState(() {});
            },
            onDarkSelected: (value) {
              prefsCubit.prefs!.selectedTheme = 1;
              prefsCubit.updatePrefs(prefsCubit.prefs!);
              setState(() {});
            },
            onDeviceSelected: (value) {
              prefsCubit.prefs!.selectedTheme = 2;
              prefsCubit.updatePrefs(prefsCubit.prefs!);
              setState(() {});
            },
          ),

          Spacer(),

          SideDivider(isExpanded: true),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [
              Text(
                'Apply Settings',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              IconButton(
                onPressed: () async {
                  await prefsCubit.updatePrefsToDB(prefsCubit.prefs!);
                  initPrefs = prefsCubit.prefs;
                },
                icon: BlocBuilder<PrefsCubit, PrefsStates>(
                  builder: (context, state) {
                    return state is PrefsLoaded
                        ? Icon(
                            Icons.check,
                          )
                        : GlobalLoading();
                  },
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
