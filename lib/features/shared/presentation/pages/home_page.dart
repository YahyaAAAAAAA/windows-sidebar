import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/packages/spring_curve/spring_curve.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_expanded.dart';
import 'package:windows_widgets/core/widgets/app/app_fitted_box.dart';
import 'package:windows_widgets/core/widgets/app/app_scaffold.dart';
import 'package:windows_widgets/core/widgets/app/app_text.dart';
import 'package:windows_widgets/core/widgets/app/buttons/primary_button.dart';
import 'package:windows_widgets/core/widgets/app/buttons/subtle_button.dart';
import 'package:windows_widgets/features/settings/presentation/pages/settings_page.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data.dart';
import 'package:windows_widgets/features/shared/presentation/components/window_widget.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/window_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isExpanded = false;
  bool pinned = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WindowCubit, List<WindowData>>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, windows) {
        final cubit = context.read<WindowCubit>();
        return AppScaffold(
          body: Stack(
            children: [
              for (final window in windows)
                WindowWidget(
                  key: ValueKey(window.id),
                  data: window,
                  onBringToFront: (id) => cubit.bringToFront(window),
                  onDragUpdated: (pos) => cubit.updatePosition(window, pos),
                  onDragEnd: (_) => cubit.toggleDrag(window),
                  onDragStarted: (_) {
                    cubit.bringToFront(window);
                    cubit.toggleDrag(window);
                  },
                ),

              //header
              Align(
                alignment: Alignment.topCenter,
                child: ExcludeFocus(
                  child: AppContainer(
                    padding: kPadding.small.pAll,
                    color: context.theme.cardColor,
                    width: context.width / 1.5,
                    curve: ElegantSpring.windows,
                    duration: kDuration.long,

                    height: pinned ? kHeader.heightHovered : kHeader.height,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(kBorderRadius.outer),
                      bottomRight: Radius.circular(kBorderRadius.outer),
                    ),
                    isAnimated: true,
                    onTap: !pinned ? () => setState(() => pinned = true) : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //logo and name
                        SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Lottie.asset(
                                    kAsset.logo,
                                    width: kLogo.width,
                                    height: kLogo.height,
                                    fit: BoxFit.cover,
                                    frameRate: const FrameRate(60),
                                    delegates: LottieDelegates(
                                      values: [
                                        ValueDelegate.color(const ['**'], value: context.theme.iconTheme.color),
                                      ],
                                    ),
                                  ),
                                  const TitleSmallText('SpotBar'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        //widgets card (activated)
                        AppExpanded(
                          flex: 0,
                          enabled: windows.isEmpty ? false : true,
                          child: AppContainer(
                            color: context.iconButtonColor,
                            elevation: 1,
                            constraints: BoxConstraints(maxWidth: context.width / 2.5),
                            width: ((windows.isEmpty ? 5 : windows.length) * kHeaderButton.width) + 1,

                            alignment: Alignment.center,
                            isAnimated: true,
                            curve: ElegantSpring.windows,
                            duration: kDuration.long,
                            child: windows.isEmpty
                                ? const LabelSmallText('Your Active Widgets Appear Here')
                                : ListView.builder(
                                    itemCount: windows.sublist(0, windows.length).length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final window = windows[index];

                                      return AppFittedBox(
                                        enabled: !pinned,
                                        child: SubtleButton(
                                          width: kHeaderButton.width,
                                          height: kHeaderButton.height,
                                          child: Icon(window.icon),
                                          onPressed: () => cubit.restoreWindow(window),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),

                        //header buttons
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: (kHeaderButtonSmall.width + kGap.small) * 2),
                          child: ListView(
                            children: [
                              Row(
                                spacing: kGap.small,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SubtleButton(
                                    width: kHeaderButtonSmall.width,
                                    height: kHeaderButtonSmall.height,
                                    onPressed: () => setState(() => pinned = !pinned),
                                    child: Icon(
                                      pinned ? FluentIcons.arrow_up_24_regular : FluentIcons.arrow_down_24_regular,
                                      size: kIconSize.tiny,
                                    ),
                                  ),
                                  PrimaryButton(
                                    width: kHeaderButtonSmall.width,
                                    height: kHeaderButtonSmall.height,
                                    onPressed: () => context.push(const SettingsWindow()),
                                    child: Icon(FluentIcons.settings_24_regular, size: kIconSize.tiny),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
