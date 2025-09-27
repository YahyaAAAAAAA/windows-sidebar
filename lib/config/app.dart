import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:windows_widgets/core/bloc/bloc_provider.dart';
import 'package:windows_widgets/core/theme/app_theme.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_cubit.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_states.dart';
import 'package:windows_widgets/features/shared/presentation/pages/home_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  ThemeData? currentTheme;

  @override
  void initState() {
    super.initState();

    currentTheme = getAppTheme(themeIndex: 0, accentColorIndex: 0, opacity: 1, useSystemAccentColor: false);
  }

  @override
  Widget build(BuildContext context) {
    return AppBlocProvider(
      child: BlocConsumer<PrefsCubit, PrefsStates>(
        listener: (context, state) {
          if (state is PrefsLoaded) {
            final prefs = state.prefs;
            currentTheme = getAppTheme(
              themeIndex: prefs.selectedTheme,
              accentColorIndex: prefs.selectedAccentColor,
              opacity: prefs.backgroundOpacity,
              useSystemAccentColor: prefs.useSystemAccentColor,
            );
          }
        },
        builder: (context, state) {
          return ToastificationWrapper(
            config: const ToastificationConfig(maxToastLimit: 2),
            child: MaterialApp(debugShowCheckedModeBanner: false, home: const HomePage(), theme: currentTheme),
          );
        },
      ),
    );
  }
}
