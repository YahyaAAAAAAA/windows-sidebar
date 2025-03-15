import 'package:flutter/material.dart';
import 'package:windows_widgets/features/main_sidebar/presentation/pages/components/side_small_button.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final double? fontSize;
  final double? elevation;
  final bool? isFilled;

  const DialogButton({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 60,
    this.height = 30,
    this.padding = const EdgeInsets.all(2),
    this.fontSize = 10,
    this.elevation = 0,
    this.isFilled = false,
  });

  @override
  Widget build(BuildContext context) {
    return SideSmallButton.text(
      width: width,
      height: height,
      padding: padding,
      onPressed: onPressed,
      buttonStyle: Theme.of(context).iconButtonTheme.style?.copyWith(
            elevation: WidgetStatePropertyAll(elevation),
            backgroundColor: isFilled == false
                ? null
                : WidgetStatePropertyAll(Theme.of(context).canvasColor),
            side: isFilled == false
                ? null
                : WidgetStatePropertyAll(BorderSide.none),
          ),
      text: Text(
        text,
        style: Theme.of(context)
            .dialogTheme
            .contentTextStyle
            ?.copyWith(fontSize: fontSize),
      ),
    );
  }
}
