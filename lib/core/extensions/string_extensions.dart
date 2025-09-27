import 'package:windows_widgets/core/extensions/int_extensions.dart';

extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  bool get isUpperCase => codeUnits.first.isBetween(65, 90);

  /// HelloMyNameFelix -> Hello My Name Felix (NOT TESTED ENOUGH)
  String splitCamelCase() {
    var result = '';
    for (int i = 0; i < length; i++) {
      if (this[i].isUpperCase) {
        for (int j = i + 1; j < length; j++) {
          if (this[j].isUpperCase || j == (length - 1)) {
            result += '${substring(i, j == (length - 1) ? j + 1 : j)} ';
            i = j - 1;
            break;
          }
        }
      }
    }

    return result.trimRight();
  }

  String removeExtension() {
    int lastDotIndex = lastIndexOf('.');

    if (lastDotIndex == -1) {
      return this;
    }

    return substring(0, lastDotIndex);
  }

  String removeSubdomain() {
    bool haveSubdomain = startsWith('www.');

    if (haveSubdomain) {
      return substring(4);
    }

    return this;
  }

  String cutFileName() {
    //find the last occurrence of the path separator (`\` or `/`)
    int lastSeparatorIndex = replaceAll('/', '\\').lastIndexOf('\\');

    //return the substring up to the last separator
    if (lastSeparatorIndex != -1) {
      return substring(0, lastSeparatorIndex);
    }

    //no file name to cut
    return this;
  }

  String getWebsiteName() {
    try {
      final uri = Uri.tryParse(this);
      //invalid url
      if (uri == null) return this;

      if (uri.host.isEmpty) return this;

      return uri.host;
    } catch (e) {
      //invalid url
      return this;
    }
  }
}
