extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
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
