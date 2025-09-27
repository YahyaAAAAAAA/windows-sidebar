import 'package:windows_widgets/core/error/failures.dart';
import 'package:windows_widgets/core/utils/logger.dart';
import 'package:windows_widgets/core/utils/toast.dart';

abstract class Warning extends Error with LogLayerMixin {
  Warning(super.error, {super.userMessage = 'Something that requires attention happened'}) {
    logWarning(error);
    Toast.warning('Warning', userMessage);
  }
}

//---ItemsRepoImpl---

class ItemsNotFoundWarning extends Warning {
  ItemsNotFoundWarning(super.error, {super.userMessage = 'Item not found'});
}

//---WindowsUtils---

class BackgroundEffectWarning extends Warning {
  BackgroundEffectWarning(super.error, {super.userMessage = 'Couldn\'t apply background effect, try again later'});
}

class SystemAccentColorWarning extends Warning {
  SystemAccentColorWarning(super.error, {super.userMessage = 'Couldn\'t apply background effect, try again later'});
}
