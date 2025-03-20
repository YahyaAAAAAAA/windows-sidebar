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

  Prefs copyWith({
    double? backgroundOpacity,
    int? selectedTheme,
    bool? isBlurred,
    bool? hasBorder,
    double? windowHeight,
  }) {
    return Prefs(
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      isBlurred: isBlurred ?? this.isBlurred,
      hasBorder: hasBorder ?? this.hasBorder,
      windowHeight: windowHeight ?? this.windowHeight,
    );
  }
}
