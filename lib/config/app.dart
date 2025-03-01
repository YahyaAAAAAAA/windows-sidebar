import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/windows/window_animation_utils_mixin.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/widgets/main_window.dart';

class WindowsWidgetsApp extends StatefulWidget {
  const WindowsWidgetsApp({super.key});

  @override
  State<WindowsWidgetsApp> createState() => _WindowsWidgetsAppState();
}

class _WindowsWidgetsAppState extends State<WindowsWidgetsApp>
    with TickerProviderStateMixin, WindowListener, WindowAnimationUtilsMixin {
  bool isExpanded = false;
  int focusHandle = 0;

  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) async {
        //todo save handle
        // focusHandle = await WindowUtils.getCurrentWindowHandle();

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
        ),
      ),
    );
  }
}
