// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:windows_widgets/core/utils/windows_utils.dart' as _i219;
import 'package:windows_widgets/features/items/data/repositories_impl/items_repo_impl.dart'
    as _i506;
import 'package:windows_widgets/features/items/domain/repositories/items_repo.dart'
    as _i689;
import 'package:windows_widgets/features/items/domain/usecases/items_add.dart'
    as _i167;
import 'package:windows_widgets/features/items/domain/usecases/items_clear_all.dart'
    as _i868;
import 'package:windows_widgets/features/items/domain/usecases/items_get_all.dart'
    as _i240;
import 'package:windows_widgets/features/items/domain/usecases/items_remove.dart'
    as _i1041;
import 'package:windows_widgets/features/items/domain/usecases/items_reorder_done.dart'
    as _i899;
import 'package:windows_widgets/features/items/domain/usecases/items_update.dart'
    as _i741;
import 'package:windows_widgets/features/items/presentation/cubits/items_cubit.dart'
    as _i504;
import 'package:windows_widgets/features/shared/data/repositories_impl/prefs_repo_impl.dart'
    as _i20;
import 'package:windows_widgets/features/shared/domain/repositories/prefs_repo.dart'
    as _i1060;
import 'package:windows_widgets/features/shared/domain/usecases/prefs_load.dart'
    as _i247;
import 'package:windows_widgets/features/shared/domain/usecases/prefs_update.dart'
    as _i324;
import 'package:windows_widgets/features/shared/presentation/cubits/prefs/prefs_cubit.dart'
    as _i720;
import 'package:windows_widgets/features/shared/presentation/cubits/window_cubit.dart'
    as _i334;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i334.WindowCubit>(() => _i334.WindowCubit());
    gh.lazySingleton<_i219.WindowsUtils>(() => _i219.WindowsUtils());
    gh.factory<_i1060.PrefsRepo>(() => _i20.PrefsRepoImpl());
    gh.factory<_i247.PrefsLoad>(() => _i247.PrefsLoad(gh<_i1060.PrefsRepo>()));
    gh.factory<_i324.PrefsSave>(() => _i324.PrefsSave(gh<_i1060.PrefsRepo>()));
    gh.factory<_i689.ItemsRepo>(() => _i506.ItemsRepoImpl());
    gh.factory<_i167.ItemsAdd>(() => _i167.ItemsAdd(gh<_i689.ItemsRepo>()));
    gh.factory<_i868.ItemsClearAll>(
      () => _i868.ItemsClearAll(gh<_i689.ItemsRepo>()),
    );
    gh.factory<_i240.ItemsGetAll>(
      () => _i240.ItemsGetAll(gh<_i689.ItemsRepo>()),
    );
    gh.factory<_i1041.ItemsRemove>(
      () => _i1041.ItemsRemove(gh<_i689.ItemsRepo>()),
    );
    gh.factory<_i899.ItemsReorderDone>(
      () => _i899.ItemsReorderDone(gh<_i689.ItemsRepo>()),
    );
    gh.factory<_i741.ItemsUpdate>(
      () => _i741.ItemsUpdate(gh<_i689.ItemsRepo>()),
    );
    gh.factory<_i504.ItemsCubit>(
      () => _i504.ItemsCubit(
        gh<_i167.ItemsAdd>(),
        gh<_i1041.ItemsRemove>(),
        gh<_i741.ItemsUpdate>(),
        gh<_i899.ItemsReorderDone>(),
        gh<_i240.ItemsGetAll>(),
        gh<_i868.ItemsClearAll>(),
      ),
    );
    gh.factory<_i720.PrefsCubit>(
      () => _i720.PrefsCubit(
        gh<_i247.PrefsLoad>(),
        gh<_i324.PrefsSave>(),
        gh<_i219.WindowsUtils>(),
      ),
    );
    return this;
  }
}
