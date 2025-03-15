import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/theme/sidebar_theme.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/data/hive_side_items_repo.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_cubit.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/main_window.dart';
import 'package:windows_widgets/features/settings_sidebar/data/shared_preferences_prefs_repo.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/cubits/prefs/prefs_cubit.dart';
import 'package:windows_widgets/features/settings_sidebar/presentation/cubits/prefs/prefs_states.dart';

class WindowsWidgetsApp extends StatefulWidget {
  const WindowsWidgetsApp({super.key});

  @override
  State<WindowsWidgetsApp> createState() => _WindowsWidgetsAppState();
}

class _WindowsWidgetsAppState extends State<WindowsWidgetsApp>
    with TickerProviderStateMixin, WindowListener, WindowAnimationUtilsMixin {
  //repos
  final itemsRepo = HiveSideItemsRepo();
  final prefsRepo = SharedPrefsRepo();

  bool shouldLoseFoucs = true;
  bool isExpanded = false;
  bool isPinned = false;
  ThemeData? currentTheme;

  int focusHandle = 0;

  void toggleExpand() => setState(() => isExpanded = !isExpanded);

  void togglePin() => setState(() => isPinned = !isPinned);

  void toggleShouldLoseFocus() =>
      setState(() => shouldLoseFoucs = !shouldLoseFoucs);

  Color accentColor = Color(0xFF4ca0e0);

  @override
  void initState() {
    super.initState();

    currentTheme = sidebarTheme(
      mainColor: themeDecider(kInitSelectedTheme),
      opacity: kInitBackgroundOpacity,
      hasBorder: kInitHasBorder,
      scaffoldPadding: kInitScaffoldPadding,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SideItemsCubit(itemsRepo: itemsRepo)),
        BlocProvider(
            create: (context) => PrefsCubit(prefsRepo: prefsRepo)..init()),
      ],
      child: MouseRegion(
        onEnter: (_) async {
          focusHandle = await WindowUtils.getCurrentWindowHandle();

          if (isPinned) return;

          //animate
          if (!isExpanded) {
            animatePositionTo(
                WindowUtils.originalPosition + Offset(kOnEnterRight, 0));
          } else {
            animatePositionTo(
                WindowUtils.originalPosition + Offset(kOnEnterRightExpand, 0));
          }
        },
        onExit: (_) {
          if (shouldLoseFoucs) {
            WindowUtils.focusPreviousWindow(focusHandle);
          }

          if (isPinned) return;

          //animate
          animatePositionTo(WindowUtils.originalPosition);
        },
        child: BlocConsumer<PrefsCubit, PrefsStates>(
          listener: (context, state) {
            if (state is PrefsLoaded) {
              final prefs = state.prefs;
              currentTheme = sidebarTheme(
                mainColor: themeDecider(prefs.selectedTheme),
                opacity: prefs.backgroundOpacity,
                hasBorder: prefs.hasBorder,
                scaffoldPadding: prefs.scaffoldPadding,
              );
            }
          },
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: MainWindow(
                isExpanded: isExpanded,
                isPinned: isPinned,
                toggleExpanded: toggleExpand,
                togglePin: togglePin,
                shouldLoseFoucs: shouldLoseFoucs,
                toggleShouldLoseFocus: toggleShouldLoseFocus,
              ),
              theme: currentTheme,
            );
          },
        ),
      ),
    );
  }
}
