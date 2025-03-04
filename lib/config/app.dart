import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/global_colors.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/data/hive_side_items_repo.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/cubits/side_items_cubit.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/main_window.dart';

class WindowsWidgetsApp extends StatefulWidget {
  const WindowsWidgetsApp({super.key});

  @override
  State<WindowsWidgetsApp> createState() => _WindowsWidgetsAppState();
}

class _WindowsWidgetsAppState extends State<WindowsWidgetsApp>
    with TickerProviderStateMixin, WindowListener, WindowAnimationUtilsMixin {
  //repos
  final itemsRepo = HiveSideItemsRepo();

  bool isExpanded = false;
  int focusHandle = 0;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SideItemsCubit(itemsRepo: itemsRepo)),
      ],
      child: MouseRegion(
        onEnter: (_) async {
          //todo save handle
          // focusHandle = await WindowUtils.getCurrentWindowHandle();

          //animate
          if (!isExpanded) {
            await animatePositionTo(
                WindowUtils.originalPosition + Offset(kOnEnterRight, 0));
          } else {
            await animatePositionTo(
                WindowUtils.originalPosition + Offset(kOnEnterRightExpand, 0));
          }
        },
        onExit: (_) {
          //todo gave focus to previous window
          // WindowUtils.focusPreviousWindow(focusHandle);

          //animate
          animatePositionTo(WindowUtils.originalPosition);
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MainWindow(
            isExpanded: isExpanded,
            toggleExpanded: toggleExpanded,
          ),
          theme: ThemeData(
              fontFamily: 'Nova',
              scaffoldBackgroundColor: GColors.windowColor,
              iconTheme: IconThemeData(
                color: GColors.windowColor.shade100,
              )),
        ),
      ),
    );
  }
}
