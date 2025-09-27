import 'package:flutter/material.dart';

extension TextExtensions on Text {
  /// Makes text bold (FontWeight.bold)
  Text bold() {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Makes text semi-bold (FontWeight.w600)
  Text semiBold() {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.w600),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Makes text light (FontWeight.w300)
  Text light() {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.w300),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Makes text italic
  Text italic() {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(fontStyle: FontStyle.italic),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Sets text color
  Text color(Color color) {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(color: color),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Makes text white
  Text white() => color(Colors.white);

  /// Makes text black
  Text black() => color(Colors.black);

  /// Makes text grey
  Text grey([int shade = 600]) => color(Colors.grey[shade]!);

  /// Makes text red
  Text red([int shade = 500]) => color(Colors.red[shade]!);

  /// Makes text blue
  Text blue([int shade = 500]) => color(Colors.blue[shade]!);

  /// Makes text green
  Text green([int shade = 500]) => color(Colors.green[shade]!);

  /// Sets font size
  Text size(double size) {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(fontSize: size),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Common size presets
  Text xs() => size(12);
  Text sm() => size(14);
  Text md() => size(16);
  Text lg() => size(18);
  Text xl() => size(20);
  Text xxl() => size(24);
  Text xxxl() => size(32);

  /// Center aligns text
  Text center() {
    return Text(
      data ?? '',
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: TextAlign.center,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Left aligns text
  Text left() {
    return Text(
      data ?? '',
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: TextAlign.left,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Right aligns text
  Text right() {
    return Text(
      data ?? '',
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: TextAlign.right,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Justifies text
  Text justify() {
    return Text(
      data ?? '',
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: TextAlign.justify,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Underlines text
  Text underline({Color? color, TextDecorationStyle? style}) {
    return Text(
      data ?? '',
      key: key,
      style: (this.style ?? const TextStyle()).copyWith(
        decoration: TextDecoration.underline,
        decorationColor: color,
        decorationStyle: style,
      ),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Strikes through text
  Text strikeThrough({Color? color, TextDecorationStyle? style}) {
    return Text(
      data ?? '',
      key: key,
      style: (this.style ?? const TextStyle()).copyWith(
        decoration: TextDecoration.lineThrough,
        decorationColor: color,
        decorationStyle: style,
      ),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Sets text overflow behavior
  Text ellipsis() {
    return Text(
      data ?? '',
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: TextOverflow.ellipsis,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Sets maximum lines
  Text maxLines(int lines) {
    return Text(
      data ?? '',
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: lines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Single line with ellipsis
  Text singleLine() => maxLines(1).ellipsis();

  /// Two lines with ellipsis
  Text twoLines() => maxLines(2).ellipsis();

  /// Sets letter spacing
  Text letterSpacing(double spacing) {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(letterSpacing: spacing),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Sets line height (line spacing)
  Text lineHeight(double height) {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(height: height),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Adds shadow to text
  Text shadow({
    Color color = Colors.black26,
    Offset offset = const Offset(1, 1),
    double blurRadius = 2,
  }) {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(
        shadows: [Shadow(color: color, offset: offset, blurRadius: blurRadius)],
      ),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Sets font family
  Text fontFamily(String fontFamily) {
    return Text(
      data ?? '',
      key: key,
      style: (style ?? const TextStyle()).copyWith(fontFamily: fontFamily),
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Makes text uppercase
  Text uppercase() {
    return Text(
      data?.toUpperCase() ?? '',
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Makes text lowercase
  Text lowercase() {
    return Text(
      data?.toLowerCase() ?? '',
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Capitalizes first letter of each word
  Text capitalize() {
    final text = data ?? '';
    final words = text.split(' ');
    final capitalizedWords = words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    });

    return Text(
      capitalizedWords.join(' '),
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: this.maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
