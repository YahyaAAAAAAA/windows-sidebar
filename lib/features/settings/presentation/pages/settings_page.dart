import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/double_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/extensions/string_extensions.dart';
import 'package:windows_widgets/core/utils/accent_colors.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/dummy.dart';
import 'package:windows_widgets/core/utils/enums/background_effect_type.dart';
import 'package:windows_widgets/core/utils/enums/theme_type.dart';
import 'package:windows_widgets/core/utils/identical.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/widgets/app/app_checkbox.dart';
import 'package:windows_widgets/core/widgets/app/app_column.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_listview.dart';
import 'package:windows_widgets/core/widgets/app/app_popup_menu.dart';
import 'package:windows_widgets/core/widgets/app/app_row.dart';
import 'package:windows_widgets/core/widgets/app/app_scaffold.dart';
import 'package:windows_widgets/core/widgets/app/app_skeletonizer.dart';
import 'package:windows_widgets/core/widgets/app/app_slider.dart';
import 'package:windows_widgets/core/widgets/app/app_switch.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/app/buttons/ghost_button.dart';
import 'package:windows_widgets/core/widgets/app/buttons/primary_button.dart';
import 'package:windows_widgets/core/widgets/dialogs/confirmation_dialog.dart';
import 'package:windows_widgets/features/settings/presentation/pages/widgets_settings_page.dart';
import 'package:windows_widgets/features/shared/domain/models/prefs.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_cubit.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_states.dart';

class SettingsWindow extends StatefulWidget {
  const SettingsWindow({super.key});

  @override
  State<SettingsWindow> createState() => _SettingsWindowState();
}

class _SettingsWindowState extends State<SettingsWindow> with LogLayerMixin {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: kPadding.medium.pButB,
      appBar: buildAppbar(context),
      body: BlocBuilder<PrefsCubit, PrefsStates>(
        builder: (context, state) {
          final cubit = context.read<PrefsCubit>();

          if (state is PrefsLoaded) {
            final prefs = state.prefs;

            return buildSettingsPage(context, prefs, cubit);
          }

          if (state is PrefsError) {
            return AppColumn(
              isCentered: true,
              isFitted: true,
              spacing: kGap.medium,
              children: [
                AppRow(
                  isCentered: true,
                  isFitted: true,
                  spacing: kGap.medium,
                  children: [const Icon(FluentIcons.error_circle_24_regular), BodyLargeText(state.message)],
                ),
                PrimaryButton(
                  padding: kPadding.medium.pHori,
                  child: const BodySmallText('Try again'),
                  onPressed: () => cubit.init(),
                ),
              ],
            );
          }

          return buildSettingsPage(context, Dummy.prefs, cubit, enabled: true);
        },
      ),
    );
  }

  Widget buildSettingsPage(BuildContext context, Prefs prefs, PrefsCubit cubit, {bool enabled = false}) {
    return AppSkeletonizer(
      enabled: enabled,
      child: AppListView(
        spacing: kGap.small,
        children: [
          const LabelLargeText('Personalization'),

          //app theme
          buildSettingsCard(
            context,
            title: 'Choose your mode',
            subTitle: 'Change the appearance of the app',
            icon: FluentIcons.paint_brush_24_regular,
            child: AppPopupMenu(
              buttonPadding: kPadding.medium.pAll,
              groupValue: prefs.selectedTheme,
              buttonElevation: kElevation.soft,
              width: kPopupMenuButton.width,
              items: [
                for (final type in ThemeType.values)
                  AppPopupMenuItem(
                    text: type.name.capitalize(),
                    value: type.index,
                    onSelected: () {
                      if (!prefs.selectedBackgroundEffect.isBetween(0, 1)) {
                        cubit.applyBackgroundEffect(
                          prefs.selectedBackgroundEffect,
                          prefs.selectedBackgroundEffect,
                          isDark: type.index == 0 ? false : true,
                        );
                      }

                      cubit.update(prefs.copyWith(selectedTheme: type.index));
                    },
                  ),
              ],
              child: BodyMediumText(ThemeType.values[prefs.selectedTheme].name.capitalize()),
            ),
          ),

          //background effect
          buildSettingsCard(
            context,
            title: 'Background effects',
            subTitle: 'Change the appearance of the app window',
            icon: FluentIcons.square_hint_sparkles_24_regular,
            child: AppPopupMenu(
              groupValue: prefs.selectedBackgroundEffect,
              buttonPadding: kPadding.medium.pAll,
              buttonElevation: kElevation.soft,
              width: kPopupMenuButton.width,
              items: [
                for (final effect in BackgroundEffectType.values)
                  AppPopupMenuItem(
                    text: effect.name.capitalize(),
                    value: effect.index,
                    onSelected: () {
                      cubit.update(
                        prefs.copyWith(
                          selectedBackgroundEffect: effect.index,
                          backgroundOpacity: effect.index.isBetween(0, 1) ? prefs.backgroundOpacity : 0,
                        ),
                      );
                      cubit.applyBackgroundEffect(
                        effect.index,
                        prefs.selectedBackgroundEffect,
                        isDark: prefs.selectedTheme == 0 ? false : true,
                      );
                    },
                  ),
              ],
              child: BodyMediumText(BackgroundEffectType.values[prefs.selectedBackgroundEffect].name.capitalize()),
            ),
          ),

          //accent color
          buildSettingsCard(
            context,
            title: 'Accent Color',
            icon: FluentIcons.color_24_regular,
            child: Row(
              children: [
                const BodySmallText('Automatic'),

                kGap.small.width,

                AppSwitch(
                  value: prefs.useSystemAccentColor,
                  trackInactiveColor: context.theme.cardColor,
                  onChanged: (value) => cubit.update(prefs.copyWith(useSystemAccentColor: value)),
                ),

                kGap.medium.width,

                AppPopupMenu(
                  enabled: !prefs.useSystemAccentColor,
                  buttonPadding: (kPadding.medium - 2).pRight,
                  buttonElevation: kElevation.soft,
                  width: 68,
                  height: 33,
                  showSelectedIndicator: true,
                  sortSelectedFirst: false,
                  menuWidth: 200,
                  menuHeight: 200,
                  groupValue: AccentColorsManager.windows11AccentColors[prefs.selectedAccentColor],
                  items: [
                    for (final color in AccentColorsManager.windows11AccentColors)
                      AppPopupMenuItem(
                        text: color.name,
                        value: color,
                        onSelected: () => cubit.update(prefs.copyWith(selectedAccentColor: color.id)),
                        leading: AppContainer(width: 20, height: 20, color: color.color),
                      ),
                  ],
                  child: AppContainer(
                    width: 33,
                    height: 33,
                    borderWidth: 0,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(kBorderRadius.outer),
                      bottomLeft: Radius.circular(kBorderRadius.outer),
                    ),
                    boxBorder: Border(right: BorderSide(color: context.theme.dividerColor)),
                    color: prefs.useSystemAccentColor ? context.theme.disabledColor : context.theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          //background opacity
          buildSettingsCard(
            context,
            title: 'Background transparency',
            subTitle: 'Change the opacity of the app window',
            icon: FluentIcons.transparency_square_24_regular,
            child: AppSlider(
              value: prefs.backgroundOpacity,
              label: prefs.backgroundOpacity.toString(),
              min: 0,
              max: 1,
              divisions: 10,
              scale: 0.9,
              width: kSlider.width,
              fit: BoxFit.fitWidth,
              onChanged: prefs.selectedBackgroundEffect.isBetween(0, 1)
                  ? (value) => cubit.update(prefs.copyWith(backgroundOpacity: value))
                  : null,
            ),
          ),

          //enable border
          buildSettingsCardTemplate(
            context,
            children: [
              AppCheckbox(
                fillColor: context.theme.cardColor,
                value: prefs.hasBorder,
                onChanged: (value) => cubit.update(prefs.copyWith(hasBorder: value)),
              ),
              const BodyMediumText('Outline app window'),

              kGap.small.width,

              AppCheckbox(
                value: prefs.mixBackgroundWithAccent,
                fillColor: context.theme.cardColor,
                onChanged: (value) => cubit.update(prefs.copyWith(mixBackgroundWithAccent: value)),
              ),
              const BodyMediumText('Mix background and accent'),
            ],
          ),

          kGap.small.height,

          const LabelLargeText('Widgets'),

          buildSettingsCard(
            context,
            title: 'Available Widgets',
            subTitle: 'Activate, hide or modify the app widgets',
            icon: FluentIcons.window_24_regular,
            onTap: () => context.push(const WidgetsSettingsPage()),
            child: GhostButton(
              onPressed: () => context.push(const WidgetsSettingsPage()),
              child: Icon(Icons.arrow_forward_ios_rounded, size: kIconSize.micro),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSettingsCard(
    BuildContext context, {
    required String title,
    required Widget child,
    double? width,
    double? height = 55,
    IconData? icon,
    String? subTitle,
    VoidCallback? onTap,
  }) {
    return AppContainer(
      padding: kPadding.medium.pAll,
      height: height,
      width: width,
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) Icon(icon),

          if (icon != null) kGap.medium.width,

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BodyMediumText(title),
              if (subTitle != null)
                LabelSmallText(
                  subTitle,
                  config: AppTextConfiguration(color: context.theme.disabledColor, fontWeight: FontWeight.normal),
                ),
            ],
          ),
          const Spacer(),

          child,
        ],
      ),
    );
  }

  Widget buildSettingsCardTemplate(
    BuildContext context, {
    required List<Widget> children,
    double? width,
    double? height = 55,
    double? spacing = 0,
    VoidCallback? onTap,
  }) {
    return AppContainer(
      padding: kPadding.medium.pAll,
      height: height,
      width: width,
      onTap: onTap,
      child: Row(spacing: kGap.small, children: children),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 169,
      leading: Padding(
        padding: kPadding.medium.pAll,
        child: BlocBuilder<PrefsCubit, PrefsStates>(
          builder: (context, state) {
            final cubit = context.read<PrefsCubit>();
            return AppContainer(
              padding: kPadding.medium.pAll,
              borderWidth: 0,
              color: state is PrefsLoaded
                  ? (state.prefs.backgroundOpacity < 1
                        ? context.theme.cardColor
                        : context.theme.scaffoldBackgroundColor)
                  : context.theme.cardColor,
              child: Row(
                spacing: kGap.medium,
                children: [
                  GhostButton(
                    onPressed: () async {
                      //user changed prefs, show confirmation dialog
                      if (state is PrefsLoaded) {
                        if (!prefsIdentical(state.prefs, cubit.initPrefs!)) {
                          context.dialog(
                            pageBuilder: (context, _, _) => ConfirmationDialog(
                              title: 'Preferences not saved are you sure?',
                              topbarChildren: const [Icon(FluentIcons.info_24_regular)],
                              topbarIconAlignLeft: true,
                              topbarSpacing: kGap.small,
                              contentSpacing: kGap.small,
                              onSavePressed: () async {
                                //save to db
                                await cubit.save(state.prefs);

                                // pop to main
                                context.pop();
                                context.pop();
                              },
                            ),
                          );
                          return;
                        }
                      }
                      //prefs stayed the same
                      context.pop();
                    },
                    child: TitleMediumText('Home', config: AppTextConfiguration(color: context.theme.disabledColor)),
                  ),
                  Icon(Icons.arrow_forward_ios, size: kIconSize.micro),
                  const GhostButton(child: TitleMediumText('Settings')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
