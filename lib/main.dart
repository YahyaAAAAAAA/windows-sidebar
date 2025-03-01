import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/app.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //initialize database factory for desktop platforms
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
      // await WindowUtils.alignRight();
      await windowManager.setAlignment(Alignment.centerRight);

      WindowUtils.originalPosition = await windowManager.getPosition();
    },
  );
  runApp(WindowsWidgetsApp());
}
