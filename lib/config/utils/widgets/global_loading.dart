import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/color_extensions.dart';

class GlobalLoading extends StatelessWidget {
  final double? width;
  final double? height;
  const GlobalLoading({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width ?? 20,
        height: height ?? 20,
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor.shade100,
        ),
      ),
    );
  }
}
