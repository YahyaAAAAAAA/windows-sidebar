import 'package:flutter/material.dart';

class SideButton extends StatelessWidget {
  final void Function()? onPressed;
  final IconData icon;
  final String text;

  const SideButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: 20,
          ),
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
