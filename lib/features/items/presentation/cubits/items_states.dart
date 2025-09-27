import 'package:windows_widgets/features/items/domain/models/app_item.dart';

abstract class ItemsStates {}

class ItemsInit extends ItemsStates {}

class ItemsLoaded extends ItemsStates {
  final List<AppItem> items;

  ItemsLoaded({required this.items});
}

class ItemsLoading extends ItemsStates {}

/// Non-critical errors, if you can emit 'Loaded' state right after. use this
class ItemsWarning extends ItemsStates {
  final Object message;

  ItemsWarning({required this.message});
}

/// Critical errors, if you can't recover
class ItemsFailure extends ItemsStates {
  final Object message;

  ItemsFailure({required this.message});
}
