extension StringExtensions on String {
  String capitalize() {
    return this[0].toUpperCase() + substring(1);
  }

  String removeExtension() {
    int lastDotIndex = lastIndexOf('.');

    if (lastDotIndex == -1) {
      return this;
    }

    return substring(0, lastDotIndex);
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
}
