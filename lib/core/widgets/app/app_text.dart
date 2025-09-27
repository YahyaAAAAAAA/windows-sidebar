import 'package:flutter/material.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';

class AppTextConfiguration {
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final String? fontFamily;
  final String? semanticsLabel;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextScaler? textScaleFactor;

  final bool? selectable;
  final bool? surface;
  const AppTextConfiguration({
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.fontFamily,
    this.selectable,
    this.surface,
    this.semanticsLabel,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.textScaleFactor,
  });

  AppTextConfiguration copyWith({
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    Color? color,
    FontWeight? fontWeight,
    double? fontSize,
    String? fontFamily,
    bool? selectable,
    bool? surface,
    String? semanticsLabel,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextScaler? textScaleFactor,
  }) {
    return AppTextConfiguration(
      style: style ?? this.style,
      textAlign: textAlign ?? this.textAlign,
      maxLines: maxLines ?? this.maxLines,
      overflow: overflow ?? this.overflow,
      color: color ?? this.color,
      fontWeight: fontWeight ?? this.fontWeight,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      selectable: selectable ?? this.selectable,
      surface: surface ?? this.surface,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    );
  }

  factory AppTextConfiguration.bold() => const AppTextConfiguration(fontWeight: FontWeight.bold);
  factory AppTextConfiguration.normal() => const AppTextConfiguration(fontWeight: FontWeight.normal);
  factory AppTextConfiguration.italic() => const AppTextConfiguration(style: TextStyle(fontStyle: FontStyle.italic));
  factory AppTextConfiguration.center() => const AppTextConfiguration(textAlign: TextAlign.center);
  factory AppTextConfiguration.surface() => const AppTextConfiguration(surface: true);
  factory AppTextConfiguration.selectable() => const AppTextConfiguration(selectable: true);
}

class AppText extends StatelessWidget {
  final String text;
  final AppTextConfiguration? config;

  const AppText(this.text, {super.key, this.config});

  @override
  Widget build(BuildContext context) {
    final AppTextConfiguration effectiveConfig = config ?? const AppTextConfiguration();

    final TextStyle effectiveStyle = (effectiveConfig.style ?? const TextStyle()).copyWith(
      color: effectiveConfig.surface == true ? context.theme.colorScheme.surface : effectiveConfig.color,
      fontWeight: effectiveConfig.fontWeight,
      fontSize: effectiveConfig.fontSize,
      fontFamily: kFontFamily,
    );

    final bool isSelectable = effectiveConfig.selectable ?? false;

    return isSelectable
        ? SelectableText(
          text,
          style: effectiveStyle,
          textAlign: effectiveConfig.textAlign,
          maxLines: effectiveConfig.maxLines,
          semanticsLabel: effectiveConfig.semanticsLabel,
          textDirection: effectiveConfig.textDirection,
        )
        : Text(
          text,
          style: effectiveStyle,
          textAlign: effectiveConfig.textAlign,
          maxLines: effectiveConfig.maxLines,
          overflow: effectiveConfig.overflow,
          semanticsLabel: effectiveConfig.semanticsLabel,
          textDirection: effectiveConfig.textDirection,
          locale: effectiveConfig.locale,
          softWrap: effectiveConfig.softWrap,
          textScaler: effectiveConfig.textScaleFactor,
        );
  }
}

//base class for themed texts
abstract class ThemedText extends AppText {
  const ThemedText(super.text, {super.key, super.config});

  TextStyle? getThemeStyle(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final themeStyle = getThemeStyle(context);
    final mergedStyle = themeStyle?.merge(config?.style) ?? config?.style;

    return AppText(text, config: config?.copyWith(style: mergedStyle) ?? AppTextConfiguration(style: mergedStyle));
  }
}

class H1 extends ThemedText {
  const H1(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.headlineLarge;
}

class H2 extends ThemedText {
  const H2(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.headlineMedium;
}

class H3 extends ThemedText {
  const H3(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.headlineSmall;
}

class BodyLargeText extends ThemedText {
  const BodyLargeText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.bodyLarge;
}

class BodyMediumText extends ThemedText {
  const BodyMediumText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.bodyMedium;
}

class BodySmallText extends ThemedText {
  const BodySmallText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.bodySmall;
}

class TitleLargeText extends ThemedText {
  const TitleLargeText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.titleLarge;
}

class TitleMediumText extends ThemedText {
  const TitleMediumText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.titleMedium;
}

class TitleSmallText extends ThemedText {
  const TitleSmallText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.titleSmall;
}

class LabelLargeText extends ThemedText {
  const LabelLargeText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.labelLarge;
}

class LabelMediumText extends ThemedText {
  const LabelMediumText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.labelMedium;
}

class LabelSmallText extends ThemedText {
  const LabelSmallText(super.text, {super.key, super.config});

  @override
  TextStyle? getThemeStyle(BuildContext context) => context.textTheme.labelSmall;
}

//for easier usage
extension AppTextExtensions on String {
  AppText toAppText([AppTextConfiguration? config]) => AppText(this, config: config);
  H1 toH1([AppTextConfiguration? config]) => H1(this, config: config);
  H2 toH2([AppTextConfiguration? config]) => H2(this, config: config);
  H3 toH3([AppTextConfiguration? config]) => H3(this, config: config);
  TitleLargeText toTitleLarge([AppTextConfiguration? config]) => TitleLargeText(this, config: config);
  TitleMediumText toTitleMedium([AppTextConfiguration? config]) => TitleMediumText(this, config: config);
  TitleSmallText toTitleSmall([AppTextConfiguration? config]) => TitleSmallText(this, config: config);
  BodyLargeText toBodyLarge([AppTextConfiguration? config]) => BodyLargeText(this, config: config);
  BodyMediumText toBodyMedium([AppTextConfiguration? config]) => BodyMediumText(this, config: config);
  BodySmallText toBodySmall([AppTextConfiguration? config]) => BodySmallText(this, config: config);
  LabelLargeText toLabelLarge([AppTextConfiguration? config]) => LabelLargeText(this, config: config);
  LabelMediumText toLabelMedium([AppTextConfiguration? config]) => LabelMediumText(this, config: config);
  LabelSmallText toLabelSmall([AppTextConfiguration? config]) => LabelSmallText(this, config: config);
}
