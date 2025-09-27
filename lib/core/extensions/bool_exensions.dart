extension BoolExensions on bool {
  double toDouble() {
    if (this) {
      return 1;
    } else {
      return 0;
    }
  }
}
