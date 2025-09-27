import 'dart:io';
import 'package:flutter/foundation.dart';

//i know it's not a "native plugin" but it fits 🦈 idc
class UrlIconPlugin {
  static Future<Uint8List?> fetchFavicon(String siteUrl) async {
    try {
      final uri = Uri.parse(siteUrl);
      final faviconUrl = Uri(
        scheme: 'https',
        host: uri.host.startsWith('www.') ? uri.host.substring(4) : uri.host,
        path: '/favicon.ico',
      );

      final httpClient = HttpClient();
      final request = await httpClient.getUrl(faviconUrl);
      final response = await request.close();

      if (response.statusCode == 200) {
        final bytes = await consolidateHttpClientResponseBytes(response);
        return bytes;
      } else {
        debugPrint('Failed to fetch favicon: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching favicon: $e');
      return null;
    }
  }
}
