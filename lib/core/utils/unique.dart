import 'dart:math';

class Unique {
  static int id() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final int randomValue = Random().nextInt(1000);
    return timestamp + randomValue;
  }

  //use modulo to keep within Hive's integer range
  static int idHive() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final int randomValue = Random().nextInt(1000);
    return (timestamp + randomValue) % 0xFFFFFFFF;
  }
}
