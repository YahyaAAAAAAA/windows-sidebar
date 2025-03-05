import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/app.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/adapters/side_file_adapter.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/adapters/side_folder_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(SideFolderAdapter());
  Hive.registerAdapter(SideFileAdapter());

  await Hive.openBox('sideItemsBox');

  await Window.initialize();
  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      alwaysOnTop: true,
      size: const Size(200, 400),
      center: false,
      title: 'WindowsWidgets',
      // titleBarStyle: TitleBarStyle.hidden,
      skipTaskbar: true,
    ),
    () async {
      // await WindowUtils.setUp();

      await WindowUtils.alignRight();
      // await windowManager.setAlignment(Alignment.centerRight);

      WindowUtils.originalPosition = await windowManager.getPosition();
    },
  );
  runApp(WindowsWidgetsApp());
}
