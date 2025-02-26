import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/utils/windows/window_utils.dart';
import 'package:windows_widgets/widgets/main_window.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      alwaysOnTop: true,
      size: const Size(200, 400),
      center: false,
      title: 'WindowsWidgets',
      titleBarStyle: TitleBarStyle.hidden,
      skipTaskbar: true,
    ),
    () async {
      // await windowManager.setAsFrameless();

      //apply transparent effect
      await Window.setEffect(effect: WindowEffect.transparent);

      //temp
      await windowManager
          .setPosition((await windowManager.getPosition()) + Offset(300, -100));

      await WindowUtils.moveWindowToRightEdge();

      runApp(WindowsWidgetsApp());
    },
  );
}

class WindowsWidgetsApp extends StatelessWidget {
  const WindowsWidgetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainWindow(),
    );
  }
}
