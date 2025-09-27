import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:windows_widgets/core/utils/unique.dart';
import 'package:windows_widgets/features/items/presentation/pages/items_window_widget.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data.dart';
import 'package:windows_widgets/features/system_items/presentation/pages/system_items_window_widget.dart';

//initial window configuration data
class WindowDataManager {
  static final List<WindowData> initialWindows = [createAppsWindow(), createSystemFilesWindow()];

  //---widget creation (fixed)---

  //apps
  static WindowData createAppsWindow() {
    final id = Unique.id();
    return WindowData(
      id: id,
      title: 'Apps',
      isFitted: true,
      icon: FluentIcons.apps_24_regular,
      child: ItemsWindowWidget(id: id),
    );
  }

  //system files
  static WindowData createSystemFilesWindow() {
    final id = Unique.id();
    return WindowData(
      id: id,
      title: 'System Files',
      isFitted: true,
      icon: FluentIcons.folder_24_regular,
      child: SystemItemsWindowWidget(id: id),
    );
  }
}
