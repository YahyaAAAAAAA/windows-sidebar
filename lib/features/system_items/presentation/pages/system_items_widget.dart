import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/core/widgets/app/app_listview.dart';
import 'package:windows_widgets/features/shared/domain/models/window_data.dart';
import 'package:windows_widgets/features/shared/presentation/components/window_topbar.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/window_cubit.dart';
import 'package:windows_widgets/features/system_items/domain/models/system_item.dart';
import 'package:windows_widgets/features/system_items/presentation/components/system_file_card.dart';

class SystemItemsWidget extends StatefulWidget {
  final int id;

  const SystemItemsWidget({super.key, required this.id});

  @override
  State<SystemItemsWidget> createState() => _SystemItemsWidgetState();
}

class _SystemItemsWidgetState extends State<SystemItemsWidget> {
  WindowCubit get cubit => context.read<WindowCubit>();
  List<SystemItem> get items => AppSystemFilesManager.appSystemFiles;
  WindowData? get window => cubit.getWindowById(widget.id);

  void restoreWindow() => cubit.restoreWindow(window);
  void closeWindow() => cubit.closeWindow(window);

  void onItemEnter(int index) => setState(() => items[index] = items[index].copyWith(isHovered: true));
  void onItemExit(int index) => setState(() => items[index] = items[index].copyWith(isHovered: false));
  void onItemFocusChange(int index, bool value) {
    setState(() => items[index] = items[index].copyWith(hasFocus: value));
    cubit.bringToFront(window);
  }

  void onItemOpen(int index) => items[index].open(context);

  FocusNode node = FocusNode();
  @override
  Widget build(BuildContext context) {
    return WindowTopBar(
      onClose: closeWindow,
      onMinimize: restoreWindow,
      child: AppContainer(
        height: kItemButton.height + kGap.medium,
        padding: kPadding.small.pAll,
        isPanel: true,
        child: AppListView(
          axis: Axis.horizontal,
          itemCount: AppSystemFilesManager.appSystemFiles.length,
          shrinkWrap: true,
          spacing: kGap.small,
          itemBuilder: (context, index) => SystemItemCard(
            item: items[index],
            onEnter: (_) => onItemEnter(index),
            onExit: (_) => onItemExit(index),
            onLeftClick: () => onItemOpen(index),
            onFocusChange: (value) => onItemFocusChange(index, value),
            isWindowDragged: window?.isDragging ?? false,
          ),
        ),
      ),
    );
  }
}
