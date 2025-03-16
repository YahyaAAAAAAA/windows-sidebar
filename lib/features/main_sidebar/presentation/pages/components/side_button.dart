import 'package:flutter/material.dart';

enum SideButtonType {
  iconExpanded,
  iconShruhk,
  imageExpanded,
  imageShrunk,
}

class SideButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final ButtonStyle? buttonStyle;
  final IconData? icon;
  final String? imagePath;
  final SideButtonType type;

  const SideButton._({
    required this.type,
    required this.text,
    this.onPressed,
    this.buttonStyle,
    this.icon,
    this.imagePath,
  });

  factory SideButton.iconExpanded({
    required IconData icon,
    required String text,
    void Function()? onPressed,
    ButtonStyle? buttonStyle,
  }) {
    return SideButton._(
      icon: icon,
      text: text,
      onPressed: onPressed,
      buttonStyle: buttonStyle,
      type: SideButtonType.iconExpanded,
    );
  }

  factory SideButton.iconShrunk({
    required IconData icon,
    required String text,
    void Function()? onPressed,
    ButtonStyle? buttonStyle,
  }) {
    return SideButton._(
      icon: icon,
      text: text,
      onPressed: onPressed,
      buttonStyle: buttonStyle,
      type: SideButtonType.iconShruhk,
    );
  }

  factory SideButton.imageExpanded({
    required String text,
    required String imagePath,
    void Function()? onPressed,
    ButtonStyle? buttonStyle,
  }) {
    return SideButton._(
      text: text,
      onPressed: onPressed,
      buttonStyle: buttonStyle,
      imagePath: imagePath,
      type: SideButtonType.imageExpanded,
    );
  }

  factory SideButton.imageShrunk({
    required String text,
    required String imagePath,
    void Function()? onPressed,
    ButtonStyle? buttonStyle,
  }) {
    return SideButton._(
      text: text,
      onPressed: onPressed,
      buttonStyle: buttonStyle,
      imagePath: imagePath,
      type: SideButtonType.imageShrunk,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case SideButtonType.iconShruhk:
        return _buildIconShrunk(context);

      case SideButtonType.iconExpanded:
        return _buildIconExpanded(context);

      case SideButtonType.imageShrunk:
        return _buildImageShrunk(context);

      default:
        return _buildImageExpanded(context);
    }
  }

  Widget _buildIconExpanded(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: 15,
        children: [
          Icon(
            icon,
            size: 20,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildIconShrunk(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 20,
          ),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }

  Widget _buildImageExpanded(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: 15,
        children: [
          Transform.scale(
            scale: 1.2,
            child: Image.asset(
              imagePath ??
                  'assets/images/folder_add.png', //placeholder just incase
              width: 24,
              height: 24,
            ),
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildImageShrunk(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Transform.scale(
            scale: 1.2,
            child: Image.asset(
              imagePath ?? 'assets/images/folder_add.png',
              width: 24,
              height: 24,
            ),
          ),
        ),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
