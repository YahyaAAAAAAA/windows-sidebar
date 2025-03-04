import 'dart:math';

class Generate {
  static int generateUniqueId() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final int randomValue = Random().nextInt(1000);
    return timestamp + randomValue;
  }
}
