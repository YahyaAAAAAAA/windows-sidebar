import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:windows_widgets/core/extensions/color_extensions.dart';
import 'package:windows_widgets/core/extensions/int_extensions.dart';
import 'package:windows_widgets/core/theme/global_colors.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/utils/toast.dart';

ThemeData getAppTheme({
  required int themeIndex,
  required int accentColorIndex,
  required double opacity,
  required bool useSystemAccentColor,
}) {
  final colors = GColors.getColors(
    themeIndex: themeIndex,
    accentColorIndex: accentColorIndex,
    useSystemAccentColor: useSystemAccentColor,
  );
  toastification.dismissAll();
  Toast.colors = colors;
  Toast.themeIndex = themeIndex;

  return ThemeData(
    fontFamily: kFontFamily,
    scaffoldBackgroundColor: colors.background.withValues(alpha: opacity),
    cardColor: colors.container,
    dividerColor: colors.divider,
    primaryColor: colors.primary,
    // splashFactory: const Windows11SplashFactory(),
    splashFactory: NoSplash.splashFactory,
    splashColor: colors.splash,
    secondaryHeaderColor: colors.secondary,
    disabledColor: colors.disabled,
    // ignore: deprecated_member_use
    indicatorColor: colors.indicator,
    tabBarTheme: TabBarThemeData(indicatorColor: colors.indicator),
    shadowColor: colors.shadow,
    hoverColor: colors.hover,
    focusColor: colors.focus,
    highlightColor: colors.highlight,
    iconTheme: IconThemeData(color: colors.icon, size: kIconSize.medium),
    appBarTheme: AppBarTheme(
      iconTheme: IconThemeData(color: colors.icon, size: kIconSize.medium),
      backgroundColor: colors.appbar,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: colors.textButton,
        elevation: kElevation.none,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius.outer)),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        backgroundColor: colors.iconButton,
        elevation: kElevation.none,
        hoverColor: colors.hover,
        shadowColor: colors.shadow,
        overlayColor: colors.splash,
        focusColor: colors.focus,
        highlightColor: colors.highlight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius.outer), side: BorderSide.none),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: colors.dialog,
      actionsPadding: kPadding.medium.pAll,
      elevation: kElevation.sharp,
      shadowColor: colors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius.outer)),
    ),
    dividerTheme: DividerThemeData(color: colors.divider),
    popupMenuTheme: PopupMenuThemeData(
      elevation: kElevation.sharp,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kBorderRadius.outer)),
      color: colors.container,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: colors.textField,
      filled: true,
      errorStyle: TextStyle(color: colors.error),
      border: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius.outer),
        borderSide: BorderSide(color: colors.disabled),
      ),
      focusedBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius.outer),
        borderSide: BorderSide(width: 2, color: colors.primary),
      ),
      enabledBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius.outer),
        borderSide: BorderSide(color: colors.disabled),
      ),
      errorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius.outer),
        borderSide: BorderSide(color: colors.error),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderRadius: BorderRadius.circular(kBorderRadius.outer),
        borderSide: BorderSide(width: 2, color: colors.error),
      ),
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        // TargetPlatform.windows: AppFadeForwardsPageTransitionsBuilder(
        //   backgroundColor: colors.background.withValues(alpha: opacity),
        // ),
        TargetPlatform.windows: FadeForwardsPageTransitionsBuilder(
          backgroundColor: colors.background.withValues(alpha: opacity > 0 && opacity < 1 ? 0 : opacity),
        ),
      },
    ),
    switchTheme: SwitchThemeData(
      overlayColor: WidgetStatePropertyAll(colors.splash),
      thumbColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.disabled;
        }
        return colors.container;
      }),
      trackColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return Colors.transparent;
        }
        return colors.primary;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
        if (states.contains(WidgetState.disabled)) {
          return colors.disabled;
        }
        return colors.primary;
      }),
    ),
    scrollbarTheme: ScrollbarThemeData(
      thickness: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.dragged) || states.contains(WidgetState.hovered)) {
          return 5;
        }
        return 3;
      }),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.primary,
      onSurface: colors.text,
      surface: colors.text.inverted,
      error: colors.error,
    ),
  );
}

//todo move out
/// A splash factory that creates Windows 11-style ripple effects
class Windows11SplashFactory extends InteractiveInkFeatureFactory {
  const Windows11SplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return Windows11Splash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

class Windows11Splash extends InteractiveInkFeature {
  Windows11Splash({
    required MaterialInkController controller,
    required super.referenceBox,
    required Offset position,
    required super.color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    super.onRemoved,
  }) : _position = position,
       _borderRadius = borderRadius ?? BorderRadius.zero,
       _customBorder = customBorder,
       _targetRadius = radius ?? _getTargetRadius(referenceBox, containedInkWell, rectCallback, position),
       _clipCallback = _getClipCallback(referenceBox, containedInkWell, rectCallback),
       super(controller: controller) {
    // Windows 11 uses a smooth, elastic animation curve
    _radiusController = AnimationController(duration: const Duration(milliseconds: 400), vsync: controller.vsync);
    _radius = Tween<double>(begin: 0.0, end: _targetRadius).animate(
      CurvedAnimation(
        parent: _radiusController,
        curve: Curves.easeOutCubic, // Smooth Windows 11-like curve
      ),
    );

    // Fade animation for opacity
    _alphaController = AnimationController(duration: const Duration(milliseconds: 300), vsync: controller.vsync);
    _alpha = Tween<double>(
      begin: 0.12, // Start with subtle opacity
      end: 0.0,
    ).animate(CurvedAnimation(parent: _alphaController, curve: Curves.easeOut));

    // Add listeners
    _radiusController.addListener(controller.markNeedsPaint);
    _alphaController.addListener(controller.markNeedsPaint);
    _radiusController.addStatusListener(_handleAlphaStatusChanged);

    // Start the animation
    _radiusController.forward();
  }

  final Offset _position;
  final BorderRadius _borderRadius;
  final ShapeBorder? _customBorder;
  final double _targetRadius;
  final RectCallback? _clipCallback;

  late AnimationController _radiusController;
  late Animation<double> _radius;
  late AnimationController _alphaController;
  late Animation<double> _alpha;

  /// Calculate the target radius for the ripple effect
  static double _getTargetRadius(
    RenderBox referenceBox,
    bool containedInkWell,
    RectCallback? rectCallback,
    Offset position,
  ) {
    final Size size = rectCallback?.call() != null ? rectCallback!().size : referenceBox.size;
    final double d1 = (position - Offset.zero).distance;
    final double d2 = (position - Offset(size.width, 0.0)).distance;
    final double d3 = (position - Offset(0.0, size.height)).distance;
    final double d4 = (position - size.bottomRight(Offset.zero)).distance;
    return [d1, d2, d3, d4].reduce((a, b) => a > b ? a : b) * 0.85; // Slightly smaller for Windows 11 feel
  }

  /// Get clipping callback for contained ink wells
  static RectCallback? _getClipCallback(RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback) {
    if (rectCallback != null) {
      return rectCallback;
    }
    if (containedInkWell) {
      return () => Offset.zero & referenceBox.size;
    }
    return null;
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _alphaController.forward();
    }
  }

  @override
  void dispose() {
    _radiusController.dispose();
    _alphaController.dispose();
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    final Paint paint = Paint()..color = color.withValues(alpha: _alpha.value);

    final Offset center = MatrixUtils.transformPoint(transform, _position);

    if (_clipCallback != null) {
      final Rect rect = _clipCallback();
      if (_customBorder != null) {
        canvas.clipPath(_customBorder.getOuterPath(rect));
      } else if (_borderRadius != BorderRadius.zero) {
        canvas.clipRRect(
          RRect.fromRectAndCorners(
            rect,
            topLeft: _borderRadius.topLeft,
            topRight: _borderRadius.topRight,
            bottomLeft: _borderRadius.bottomLeft,
            bottomRight: _borderRadius.bottomRight,
          ),
        );
      } else {
        canvas.clipRect(rect);
      }
    }

    // Draw the Windows 11-style circular ripple
    canvas.drawCircle(center, _radius.value, paint);
  }

  @override
  void confirm() {
    // Start fade out immediately when confirmed (touch release)
    _alphaController.forward();
  }

  @override
  void cancel() {
    // Quick fade out on cancel
    _alphaController.duration = const Duration(milliseconds: 150);
    _alphaController.forward();
  }
}
