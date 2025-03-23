import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/identical.dart';
import 'package:windows_widgets/config/utils/transition_animation.dart';
import 'package:windows_widgets/config/utils/widgets/app_scaffold.dart';
import 'package:windows_widgets/config/utils/widgets/fade_effect.dart';
import 'package:windows_widgets/config/utils/widgets/global_loading.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_cubit.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_button.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/models/prefs.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/cubits/prefs/prefs_cubit.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/cubits/prefs/prefs_states.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/components/blur_row.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/components/clear_all_items_button.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/pages/components/dialogs/prefs_save_dialog.dart';
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
  late final SideItemsCubit sideItemsCubit;
  late final PrefsCubit prefsCubit;
  Prefs? initPrefs;
  double windowHeight = 0;

  @override
  void initState() {
    super.initState();

    prefsCubit = context.read<PrefsCubit>();
    sideItemsCubit = context.read<SideItemsCubit>();

    initPrefs = prefsCubit.prefs?.copyWith();
    windowHeight = prefsCubit.prefs!.windowHeight;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Column(
        children: [
          SideButton.iconShrunk(
            icon: Icons.arrow_back_ios_new_rounded,
            text: 'Sidebar Settings',
            onPressed: () async {
              //user changed prefs, show confirmation dialog
              if (!prefsIdentical(prefsCubit.prefs!, initPrefs!)) {
                context.dialog(
                  transitionBuilder: TransitionAnimations.slideFromBottom,
                  pageBuilder: (context, _, __) => PrefsSaveDialog(
                    onSavePressed: () async {
                      //pop dialog first

                      final initContext = context;
                      //save to db
                      await prefsCubit.save(prefsCubit.prefs!);
                      initPrefs = prefsCubit.prefs;

                      if (initContext.mounted) {
                        //pop to main
                        context.pop();
                        context.pop();
                      }
                    },
                  ),
                );
                return;
              }
              //prefs stayed the same
              context.pop();
            },
          ),

          SideDivider(isExpanded: true),

          //resize
          Expanded(
            child: FadeEffect(
              child: ListView(
                children: [
                  SizedBox(height: 10),

                  ResizeRow(
                    windowHeight: windowHeight.ceilToDouble(),
                    onUpPressed: () => setState(() => windowHeight += 10),
                    onDownPressed: () => setState(() => windowHeight -= 10),
                    onDonePressed: () async {
                      await animateSizeTo(
                          Size(kWindowWidth, windowHeight.ceilToDouble()));
                      prefsCubit.prefs!.windowHeight =
                          windowHeight.ceilToDouble();
                    },
                  ),

                  SizedBox(height: 10),

                  //theme
                  ThemeRow(
                    selectedTheme: prefsCubit.prefs!.selectedTheme,
                    onDefaultSelected: (value) {
                      prefsCubit.prefs!.selectedTheme = 0;
                      prefsCubit.update(prefsCubit.prefs!);
                      setState(() {});
                    },
                    onDeviceSelected: (value) {
                      prefsCubit.prefs!.selectedTheme = 1;
                      prefsCubit.update(prefsCubit.prefs!);

                      setState(() {});
                    },
                    onLightSelected: (value) {
                      prefsCubit.prefs!.selectedTheme = 2;
                      prefsCubit.update(prefsCubit.prefs!);
                      setState(() {});
                    },
                    onDarkSelected: (value) {
                      prefsCubit.prefs!.selectedTheme = 3;
                      prefsCubit.update(prefsCubit.prefs!);
                      setState(() {});
                    },
                  ),
                  SizedBox(height: 10),

                  //clear all button
                  DeleteAllItemsButton(
                    onPressed: () async => await sideItemsCubit.clearAll(),
                  ),

                  SizedBox(height: 20),

                  //opacity
                  OpacityRow(
                    sliderValue: prefsCubit.prefs!.backgroundOpacity,
                    onChanged: (value) {
                      prefsCubit.prefs!.backgroundOpacity = value;
                      prefsCubit.update(prefsCubit.prefs!);
                      setState(() {});
                    },
                  ),

                  SizedBox(height: 10),

                  //blur, border boxes
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

                      prefsCubit.update(prefsCubit.prefs!);
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),

          SideDivider(isExpanded: true),

          SizedBox(height: 5),

          //todo should be moved to its own widget
          //save to db
          BlocBuilder<PrefsCubit, PrefsStates>(builder: (context, state) {
            return IconButton(
              onPressed: state is PrefsLoading
                  ? null
                  : () async {
                      await prefsCubit.save(prefsCubit.prefs!);
                      initPrefs = prefsCubit.prefs;
                    },
              style: Theme.of(context).iconButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                      Theme.of(context).scaffoldBackgroundColor.shade600,
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Theme.of(context).primaryColor.shade300,
                        width: 0.5,
                      ),
                    ),
                  ),
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                spacing: 5,
                children: [
                  Text(
                    'Apply Settings',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  state is PrefsLoading ? GlobalLoading() : Icon(Icons.check)
                ],
              ),
            );
          }),

          SizedBox(height: 5),
        ],
      ),
    );
  }
}
