import 'package:windows_widgets/features/main_sidebar/domain/models/side_item.dart';

abstract class SideItemsStates {}

class SideItemsInit extends SideItemsStates {}

class SideItemsLoaded extends SideItemsStates {
  final List<SideItem> items;

  SideItemsLoaded({required this.items});
}

class SideItemsLoading extends SideItemsStates {}

class SideItemsError extends SideItemsStates {
  final String message;

  SideItemsError({required this.message});
}
