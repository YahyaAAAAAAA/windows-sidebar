import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/core/extensions/build_context_extensions.dart';
import 'package:windows_widgets/core/extensions/color_extensions.dart';
import 'package:windows_widgets/core/utils/constants.dart';
import 'package:windows_widgets/core/widgets/app/app_container.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_cubit.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_states.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrefsCubit, PrefsStates>(
      builder:
          (context, state) => AppContainer(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(kBorderRadius.window),
            borderWidth:
                state is PrefsLoaded ? (state.prefs.hasBorder ? 1 : 0) : null,
            child: Scaffold(
              appBar: appBar,
              backgroundColor:
                  backgroundColor ??
                  (state is PrefsLoaded
                      ? context.theme.scaffoldBackgroundColor.mix(
                        context.primaryColor,
                        state.prefs.mixBackgroundWithAccent ? 0.08 : 0,
                      )
                      : context.theme.scaffoldBackgroundColor),
              body: Padding(
                padding: padding ?? const EdgeInsets.all(0),
                child: body,
              ),
              bottomNavigationBar: bottomNavigationBar,
            ),
          ),
    );
  }
}
