import 'package:flutter/material.dart';

class SideButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final String text;
  final ButtonStyle? buttonStyle;
  final bool isExpanded;

  const SideButton._({
    required this.icon,
    required this.text,
    this.onPressed,
    this.buttonStyle,
    required this.isExpanded,
  });

  factory SideButton.expanded({
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
      isExpanded: true,
    );
  }

  factory SideButton.shrunk({
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
      isExpanded: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return isExpanded ? _buildExpanded(context) : _buildShrunk(context);
  }

  Widget _buildExpanded(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Row(
        mainAxisSize: MainAxisSize.max,
        spacing: 15,
        children: [
          //TODO here
          Image.asset(
            'assets/images/folder_add.png',
            width: 30,
            height: 30,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildShrunk(BuildContext context) {
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
}
