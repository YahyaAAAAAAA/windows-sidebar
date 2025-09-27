import 'package:flutter/material.dart';

extension WidgetExtensions on Widget {
  SizedBox hide() {
    return const SizedBox();
  }

  String toName<T extends Widget>() => T.toString();
}
