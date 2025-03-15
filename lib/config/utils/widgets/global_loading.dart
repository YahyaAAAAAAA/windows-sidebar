import 'package:flutter/material.dart';

class GlobalLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const GlobalLoading({
    super.key,
    this.width = 20,
    this.height = 20,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedAlign(
      duration: Duration(milliseconds: 300),
      alignment: alignment ?? Alignment.center,
      child: SizedBox(
        width: width,
        height: height,
        child: CircularProgressIndicator(
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
