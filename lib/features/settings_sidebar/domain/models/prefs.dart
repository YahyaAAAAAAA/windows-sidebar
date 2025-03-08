class Prefs {
  int selectedTheme;
  double backgroundOpacity;
  double windowHeight;
  bool isBlurred;
  bool hasBorder;

  Prefs({
    required this.selectedTheme,
    required this.backgroundOpacity,
    required this.windowHeight,
    required this.isBlurred,
    required this.hasBorder,
  });

  Map<String, dynamic> toJSON() {
    return {
      'selectedTheme': selectedTheme,
      'backgroundOpacity': backgroundOpacity,
      'windowHeight': windowHeight,
      'isBlurred': isBlurred,
      'hasBorder': hasBorder,
    };
  }
}
