import 'package:flutter/material.dart';

extension ListWidgetExtensions on List<Widget> {
  List<Widget> separated(Widget separator) {
    if (isEmpty) return this;

    final result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(separator);
      }
    }
    return result;
  }

  List<Widget> separatedDynamic(Widget Function(int index) spacingBuilder) {
    if (isEmpty) return this;

    final result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        final spacing = spacingBuilder(i);
        result.add(spacing);
      }
    }
    return result;
  }
}
