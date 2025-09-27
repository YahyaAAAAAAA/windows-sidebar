import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:windows_widgets/core/database/hive/hive_adapters/app_file_adapter.dart';
import 'package:windows_widgets/core/database/hive/hive_adapters/app_folder_adapter.dart';
import 'package:windows_widgets/core/database/hive/hive_adapters/app_url_adapter.dart';
import 'package:windows_widgets/core/database/hive/hive_adapters/prefs_adapter.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/features/items/domain/models/app_item.dart';

Future<void> configureHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(AppFolderAdapter());
  Hive.registerAdapter(AppFileAdapter());
  Hive.registerAdapter(AppUrlAdapter());
  Hive.registerAdapter(PrefsAdapter());

  await Hive.openBox<AppItem>(kHiveBox.items);
  await Hive.openBox(kHiveBox.prefs);
}
