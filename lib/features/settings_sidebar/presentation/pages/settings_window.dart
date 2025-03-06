import 'package:flutter/material.dart';
import 'package:flutter_acrylic/window_effect.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/build_context_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_button.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_divider.dart';
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
  double windowHeight = 0;
  WindowEffect effect = WindowEffect.solid;

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
            child: BlocConsumer<PrefsCubit, PrefsStates>(
              listener: (context, state) {
                if (state is PrefsError) {
                  debugPrint(state.message);
                }
              },
              builder: (context, state) {
                if (state is PrefsLoaded) {
                  final prefs = state.prefs;
                  return Column(
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
                        onDonePressed: () async => await animateSizeTo(
                            Size(200, windowHeight.ceilToDouble())),
                      ),

                      SizedBox(height: 10),

                      //opacity slider
                      OpacityRow(
                        sliderValue: prefs.backgroundOpacity,
                        onChanged: (value) {
                          prefs.backgroundOpacity = value;
                          prefsCubit.setOpacity(prefs);
                          setState(() {});
                        },
                      ),

                      SizedBox(height: 10),

                      //blur, solid radios
                      BlurRow(
                        radioValue: prefs.isBlurred,
                        onBlur: (value) async {
                          prefs.isBlurred = true;
                          await WindowUtils.blur();

                          setState(() {});
                        },
                        onNoBlur: (value) async {
                          prefs.isBlurred = false;
                          await WindowUtils.transparent();

                          setState(() {});
                        },
                      ),

                      SizedBox(height: 10),

                      //sidebar theme
                      ThemeRow(
                        selectedTheme: prefs.selectedTheme,
                        onLightSelected: (value) {
                          prefs.selectedTheme = 0;
                          prefsCubit.setTheme(prefs);
                          setState(() {});
                        },
                        onDarkSelected: (value) {
                          prefs.selectedTheme = 1;
                          prefsCubit.setTheme(prefs);
                          setState(() {});
                        },
                        onDeviceSelected: (value) {
                          prefs.selectedTheme = 2;
                          prefsCubit.setTheme(prefs);
                          setState(() {});
                        },
                      ),

                      Spacer(),

                      SideDivider(isExpanded: true),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 10,
                        children: [
                          Text(
                            'Apply Settings',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          IconButton(
                            onPressed: () async {
                              await prefsCubit.updatePrefs(prefs);
                            },
                            icon: Icon(
                              Icons.check,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),
                    ],
                  );
                }
                //todo global
                return CircularProgressIndicator();
              },
            ),
          ),
        ),
      ),
    );
  }
}
