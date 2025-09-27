class Prefs {
  int selectedTheme;
  double backgroundOpacity;
  double windowHeight;
  double windowWidth;
  int selectedBackgroundEffect;
  int selectedAccentColor;
  bool hasBorder;
  bool useSystemAccentColor;
  bool mixBackgroundWithAccent;

  Prefs({
    required this.selectedTheme,
    required this.backgroundOpacity,
    required this.windowHeight,
    required this.windowWidth,
    required this.selectedBackgroundEffect,
    required this.selectedAccentColor,
    required this.hasBorder,
    required this.mixBackgroundWithAccent,
    required this.useSystemAccentColor,
  });

  Map<String, dynamic> toJSON() {
    return {
      'selectedTheme': selectedTheme,
      'selectedBackgroundEffect': selectedBackgroundEffect,
      'backgroundOpacity': backgroundOpacity,
      'selectedAccentColor': selectedAccentColor,
      'windowHeight': windowHeight,
      'windowWidth': windowWidth,
      'hasBorder': hasBorder,
      'mixBackgroundWithAccent': mixBackgroundWithAccent,
      'useSystemAccentColor': useSystemAccentColor,
    };
  }

  Prefs copyWith({
    double? backgroundOpacity,
    int? selectedTheme,
    int? selectedBackgroundEffect,
    int? selectedAccentColor,
    double? windowHeight,
    double? windowWidth,
    bool? hasBorder,
    bool? mixBackgroundWithAccent,
    bool? useSystemAccentColor,
  }) {
    return Prefs(
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      selectedTheme: selectedTheme ?? this.selectedTheme,
      selectedBackgroundEffect:
          selectedBackgroundEffect ?? this.selectedBackgroundEffect,
      selectedAccentColor: selectedAccentColor ?? this.selectedAccentColor,
      hasBorder: hasBorder ?? this.hasBorder,
      windowHeight: windowHeight ?? this.windowHeight,
      windowWidth: windowWidth ?? this.windowWidth,
      mixBackgroundWithAccent:
          mixBackgroundWithAccent ?? this.mixBackgroundWithAccent,
      useSystemAccentColor: useSystemAccentColor ?? this.useSystemAccentColor,
    );
  }
}
