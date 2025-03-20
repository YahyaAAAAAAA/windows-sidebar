import 'package:flutter/services.dart';

class WindowAeroBlur {
  static const MethodChannel _channel = MethodChannel('file_icon_channel');

  static Future<void> applyAeroBlur() async {
    await _channel.invokeMethod('applyBlur');
  }
}
