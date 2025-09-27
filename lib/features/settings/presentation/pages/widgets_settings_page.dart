import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/double_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_listview.dart';
import 'package:windows_widgets/core/widgets/app/app_scaffold.dart';
import 'package:windows_widgets/core/widgets/app/app_switch.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/app/buttons/ghost_button.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data_manager.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/window_cubit.dart';

class WidgetsSettingsPage extends StatefulWidget {
  const WidgetsSettingsPage({super.key});

  @override
  State<WidgetsSettingsPage> createState() => _WidgetsSettingsPageState();
}

class _WidgetsSettingsPageState extends State<WidgetsSettingsPage>
    with LogMixin {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: kPadding.medium.pButB,
      appBar: buildAppbar(context),
      body: BlocBuilder<WindowCubit, List<WindowData>>(
        builder: (context, state) {
          final cubit = context.read<WindowCubit>();

          return AppListView(
            spacing: kGap.small,
            children: [
              for (final window in WindowDataManager.initialWindows)
                buildSettingsCard(
                  context,
                  title: window.title ?? window.id.toString(),
                  icon: window.icon,
                  child: Row(
                    children: [
                      AppSwitch(
                        value: cubit.exists(window),
                        onChanged: (value) {
                          if (!value) {
                            cubit.closeWindow(window);
                            return;
                          }
                          cubit.createWindow(window);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
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
                  config: AppTextConfiguration(
                    color: context.theme.disabledColor,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
          const Spacer(),

          child,
        ],
      ),
    );
  }

  AppBar buildAppbar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leadingWidth: 170,
      leading: Padding(
        padding: kPadding.medium.pAll,
        child: Row(
          spacing: kGap.medium,
          children: [
            GhostButton(
              onPressed: () => context.pop(),
              child: TitleMediumText(
                'Settings',
                config: AppTextConfiguration(
                  color: context.theme.disabledColor,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: kIconSize.micro),
            const GhostButton(child: TitleMediumText('Widgets')),
          ],
        ),
      ),
    );
  }
}
