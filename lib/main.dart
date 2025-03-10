import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/app.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/adapters/side_file_adapter.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/adapters/side_folder_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  //register adapters
  Hive.registerAdapter(SideFolderAdapter());
  Hive.registerAdapter(SideFileAdapter());

  await Hive.openBox('sideItemsBox');

  //i know this is ugly and wrong, but it works 🤷‍♂️
  final prefs = await SharedPreferences.getInstance();
  final windowHeight = prefs.getDouble('windowHeight') ?? kWindowHeight;

  await Window.initialize();
  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      alwaysOnTop: true,
      size: Size(kWindowWidth, windowHeight),
      maximumSize: Size(kWindowWidth, kWindowMaxHeight),
      minimumSize: Size(kWindowWidth, kWindowMinHeight),
      center: false,
      title: 'WindowsSidebar',
      skipTaskbar: true,
    ),
    () async {
      await WindowUtils.setUp();

      await WindowUtils.alignRight();

      WindowUtils.originalPosition = await windowManager.getPosition();

      runApp(WindowsWidgetsApp());
    },
  );
}
