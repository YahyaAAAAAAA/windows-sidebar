import 'package:flutter/material.dart';
import 'package:windows_widgets/config/extensions/build_context.dart';
import 'package:windows_widgets/config/utils/constants.dart';
import 'package:windows_widgets/widgets/components/side_button.dart';

class SettingsWindow extends StatefulWidget {
  const SettingsWindow({super.key});

  @override
  State<SettingsWindow> createState() => _SettingsWindowState();
}

class _SettingsWindowState extends State<SettingsWindow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kOuterRadius),
          bottomLeft: Radius.circular(kOuterRadius),
        ),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(6),
            child: Column(
              children: [
                SideButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  text: 'Back',
                  onPressed: () => context.pop(),
                ),
                Text('Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
