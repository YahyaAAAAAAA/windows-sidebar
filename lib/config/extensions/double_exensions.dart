extension DoubleExensions on double {
  bool toBool() {
    if (this >= 1) {
      return true;
    } else {
      return false;
    }
  }
}
