import 'package:flutter/material.dart';
import 'package:windows_widgets/core/utils/transition_animation.dart';

// Context Extensions
extension ContextExtensions on BuildContext {
  void push(
    Widget child, {
    Duration? duration,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionBuilder,
  }) {
    //transitions moved to theme data
    Navigator.of(this).push(MaterialPageRoute(builder: (context) => child));
  }

  void replace(
    Widget child, {
    Duration? duration,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionBuilder,
  }) {
    Navigator.of(this).pushReplacement(
      PageRouteBuilder(
        transitionDuration: duration ?? const Duration(milliseconds: 500),
        reverseTransitionDuration:
            duration ?? const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => child,
        transitionsBuilder: transitionBuilder ?? TransitionAnimations.fade,
      ),
    );
  }

  // void pop() {
  //   Navigator.of(this).pop();
  // }

  //animated dialog
  Future<Object?> dialog({
    required Widget Function(BuildContext, Animation<double>, Animation<double>)
    pageBuilder,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionBuilder,
    bool? barrierDismissible,
    Duration? transitionDuration,
  }) async {
    return showGeneralDialog(
      context: this,
      pageBuilder: pageBuilder,
      barrierLabel: '',
      barrierDismissible: barrierDismissible ?? true,
      transitionDuration:
          transitionDuration ?? const Duration(milliseconds: 200),
      transitionBuilder:
          transitionBuilder ??
          (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
    );
  }

  /// return screen size
  Size size() => MediaQuery.sizeOf(this);

  /// return screen width
  double get width => MediaQuery.sizeOf(this).width;

  /// return screen height
  double get height => MediaQuery.sizeOf(this).height;

  /// return screen devicePixelRatio
  double pixelRatio() => MediaQuery.devicePixelRatioOf(this);

  /// returns brightness
  Brightness platformBrightness() => MediaQuery.platformBrightnessOf(this);

  /// Return the height of status bar
  double get statusBarHeight => MediaQuery.viewPaddingOf(this).top;

  /// Return the height of navigation bar
  double get navigationBarHeight => MediaQuery.viewPaddingOf(this).bottom;

  /// Returns Theme.of(context)
  ThemeData get theme => Theme.of(this);

  /// Returns Theme.of(context).textTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Returns DefaultTextStyle.of(context)
  DefaultTextStyle get defaultTextStyle => DefaultTextStyle.of(this);

  /// Returns Form.of(context)
  FormState? get formState => Form.of(this);

  /// Returns Scaffold.of(context)
  ScaffoldState get scaffoldState => Scaffold.of(this);

  /// Returns Overlay.of(context)
  OverlayState? get overlayState => Overlay.of(this);

  /// Returns primaryColor Color
  Color get primaryColor => theme.primaryColor;

  /// Returns accentColor Color
  Color get accentColor => theme.colorScheme.secondary;

  /// Returns scaffoldBackgroundColor Color
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  /// Returns cardColor Color
  Color get cardColor => theme.cardColor;

  /// Returns dividerColor Color
  Color get dividerColor => theme.dividerColor;

  /// Returns dividerColor Color
  Color get iconColor => theme.iconTheme.color!;

  Color get iconButtonColor =>
      theme.iconButtonTheme.style?.backgroundColor?.resolve({}) ??
      theme.cardColor;

  /// Request focus to given FocusNode
  void requestFocus(FocusNode focus) {
    FocusScope.of(this).requestFocus(focus);
  }

  /// Request focus to given FocusNode
  void unFocus(FocusNode focus) {
    focus.unfocus();
  }

  /// return orientation
  Orientation get orientation => MediaQuery.orientationOf(this);

  /// return true if orientation is landscape
  bool get isLandscape => orientation == Orientation.landscape;

  /// return true if orientation is portrait
  bool get isPortrait => orientation == Orientation.portrait;

  /// return true if can pop
  bool get canPop => Navigator.canPop(this);

  /// return true if can pop With result
  void pop<T extends Object>([T? result]) => Navigator.pop(this, result);

  /// return platform type
  TargetPlatform get platform => Theme.of(this).platform;

  /// return true if running on Android
  bool get isAndroid => platform == TargetPlatform.android;

  /// return true if running on iOS
  bool get isIOS => platform == TargetPlatform.iOS;

  /// return true if running on MacOS
  bool get isMacOS => platform == TargetPlatform.macOS;

  /// return true if running on Windows
  bool get isWindows => platform == TargetPlatform.windows;

  /// return true if running on Fuchsia
  bool get isFuchsia => platform == TargetPlatform.fuchsia;

  /// return true if running on Linux
  bool get isLinux => platform == TargetPlatform.linux;

  /// Open drawer
  void openDrawer() => Scaffold.of(this).openDrawer();

  /// Close drawer
  void closeDrawer() => Scaffold.of(this).closeDrawer();

  /// Open end drawer
  void openEndDrawer() => Scaffold.of(this).openEndDrawer();

  /// Close end drawer
  void closeEndDrawer() => Scaffold.of(this).closeEndDrawer();

  /// Show SnackBar
  void showSnackBar(String snackBarWidget) => ScaffoldMessenger.of(
    this,
  ).showSnackBar(
    SnackBar(
      content: Text(snackBarWidget),
      backgroundColor: theme.canvasColor,
      duration: const Duration(seconds: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  /// Hide SnackBar
  void hideSnackBar() => ScaffoldMessenger.of(this).hideCurrentSnackBar();
}
