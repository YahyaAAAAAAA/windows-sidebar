import 'package:flutter/material.dart';
import 'package:windows_widgets/config/app.dart';
import 'package:windows_widgets/core/database/hive/hive_init.dart';
import 'package:windows_widgets/core/di/dependency_injection.dart';
import 'package:windows_widgets/core/utils/windows_utils.dart';

const _forceExceptionEnabled = true; //incase i forgot to delete the method
void forceException() => _forceExceptionEnabled ? throw Exception('Test') : null;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //di
  await configureDependencies();

  //hive
  await configureHive();

  //windows
  await getIt<WindowsUtils>().init();

  runApp(const App());
}
