import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:windows_widgets/core/di/dependency_injection.dart';
import 'package:windows_widgets/features/items/presentation/cubits/items_cubit.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_cubit.dart';
import 'package:windows_widgets/features/shared/presentation/cubits/window_cubit.dart';

class AppBlocProvider extends StatelessWidget {
  final Widget child;

  const AppBlocProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ItemsCubit>()),
        BlocProvider(create: (context) => getIt<PrefsCubit>()..init()),
        BlocProvider(create: (context) => getIt<WindowCubit>()),
      ],
      child: child,
    );
  }
}
