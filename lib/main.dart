import 'package:flutter/material.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_widgets/config/app.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/config/utils/windows/window_utils.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/adapters/side_file_adapter.dart';
import 'package:windows_widgets/features/main_sidebar/domain/models/adapters/side_folder_adapter.dart';
import 'package:windows_widgets/features/settings_sidebar/domain/models/adapters/prefs_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  //register adapters
  Hive.registerAdapter(SideFolderAdapter());
  Hive.registerAdapter(SideFileAdapter());
  Hive.registerAdapter(PrefsAdapter());

  await Hive.openBox('sideItemsBox');
  final tempPrefsBox = await Hive.openBox('prefsBox');

  //i know this is ugly and wrong, but it works 🤷‍♂️
  final windowHeight = tempPrefsBox.get('windowHeight') ?? kWindowHeight;

  await Window.initialize();
  await windowManager.ensureInitialized();

  await windowManager.waitUntilReadyToShow(
    WindowOptions(
      alwaysOnTop: true,
      size: Size(kWindowWidth, windowHeight),
      maximumSize: Size(kWindowWidth, kWindowMaxHeight),
      minimumSize: Size(kWindowWidth, kWindowMinHeight),
      center: true,
      title: 'WindowsSidebar',
      titleBarStyle: TitleBarStyle.hidden,
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
