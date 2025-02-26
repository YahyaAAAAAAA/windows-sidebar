import 'package:flutter/services.dart';

class FileIconPlugin {
  static const MethodChannel _channel = MethodChannel('file_icon_channel');

  static Future<Uint8List?> getFileIcon(String filePath) async {
    try {
      final Uint8List? iconBytes =
          await _channel.invokeMethod('getFileIcon', filePath);
      return iconBytes;
    } catch (e) {
      print("Error retrieving file icon: $e");
      return null;
    }
  }
}
