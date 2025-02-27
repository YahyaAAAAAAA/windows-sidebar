import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/widgets/main_window.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database factory for desktop platforms
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

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
      await WindowUtils.setUp();
      // await WindowUtils.transparent();
      await WindowUtils.alignRight();
      // await windowManager.setAlignment(Alignment.centerRight);

      WindowUtils.originalPosition = await windowManager.getPosition();
    },
  );
  runApp(WindowsWidgetsApp());
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
