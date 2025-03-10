import 'package:flutter/material.dart';

class NoItemsRow extends StatelessWidget {
  final bool isExpanded;

  const NoItemsRow({
    required this.isExpanded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedAlign(
        duration: Duration(milliseconds: 300),
        alignment: isExpanded ? Alignment.center : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 5),
            Icon(
              Icons.keyboard_double_arrow_down_rounded,
              size: 30,
            ),
            SizedBox(width: 10),
            Text(
              'Add Shortcuts',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
      ),
    );
  }
}
