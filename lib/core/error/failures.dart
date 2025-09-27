import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/utils/toast.dart';

abstract class Error {
  final Object error;
  final String userMessage;

  Error(this.error, {this.userMessage = 'An error occurred'});
}

abstract class Failure extends Error with LogLayerMixin {
  Failure(super.error, {super.userMessage = 'A failure occurred'}) {
    logError(error);
    Toast.error('Failure', userMessage);
  }
}

//---PrefsRepoImpl----

class PrefsLoadFailure extends Failure {
  PrefsLoadFailure(super.error, {super.userMessage = 'A failure occurred while loading preferences'});
}

class PrefsSaveFailure extends Failure {
  PrefsSaveFailure(super.error, {super.userMessage = 'A failure occurred while saving preferences'});
}

//---ItemsRepoImpl---

class ItemsAddFailure extends Failure {
  ItemsAddFailure(super.error, {super.userMessage = 'A failure occurred while adding an item'});
}

class ItemsRemoveFailure extends Failure {
  ItemsRemoveFailure(super.error, {super.userMessage = 'A failure occurred while removing an item'});
}

class ItemsUpdateFailure extends Failure {
  ItemsUpdateFailure(super.error, {super.userMessage = 'A failure occurred while updating an item'});
}

class ItemsGetAllFailure extends Failure {
  ItemsGetAllFailure(super.error, {super.userMessage = 'A failure occurred while getting items from the database'});
}

class ItemsClearAllFailure extends Failure {
  ItemsClearAllFailure(super.error, {super.userMessage = 'A failure occurred while clearing items from the database'});
}

class ItemsReorderDoneFailure extends Failure {
  ItemsReorderDoneFailure(super.error, {super.userMessage = 'A failure occurred on items reorder'});
}

//---WindowsUtils---

class WindowsInitFailure extends Failure {
  WindowsInitFailure(super.error, {super.userMessage = 'A failure occurred while initializing windows'});
}
