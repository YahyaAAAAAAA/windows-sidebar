extension StringExtensions on String {
  String removeExtension() {
    int lastDotIndex = lastIndexOf('.');

    if (lastDotIndex == -1) {
      return this;
    }

    return substring(0, lastDotIndex);
  }
}
