// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:gallery/core/di/injection.dart' as _i785;
import 'package:gallery/data/datasources/api_service.dart' as _i452;
import 'package:gallery/data/datasources/local_data_source.dart' as _i9;
import 'package:gallery/data/datasources/network_service.dart' as _i718;
import 'package:gallery/data/datasources/remote_data_source.dart' as _i1053;
import 'package:gallery/data/repositories/photo_repository.dart' as _i208;
import 'package:gallery/data/repositories/photo_repository_impl.dart' as _i496;
import 'package:gallery/domain/usecases/get_photos_usecase.dart' as _i498;
import 'package:gallery/presentation/cubit/photo_cubit.dart' as _i115;
import 'package:gallery/presentation/cubit/theme_cubit.dart' as _i135;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i135.ThemeCubit>(() => _i135.ThemeCubit());
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i9.LocalDataSource>(() => _i9.LocalDataSourceImpl());
    gh.lazySingleton<_i452.ApiService>(
        () => registerModule.apiService(gh<_i361.Dio>()));
    gh.lazySingleton<_i718.NetworkService>(
        () => _i718.NetworkServiceImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i1053.RemoteDataSource>(
        () => _i1053.RemoteDataSourceImpl(gh<_i452.ApiService>()));
    gh.lazySingleton<_i208.PhotoRepository>(() => _i496.PhotoRepositoryImpl(
          gh<_i1053.RemoteDataSource>(),
          gh<_i9.LocalDataSource>(),
          gh<_i718.NetworkService>(),
        ));
    gh.factory<_i498.GetPhotosUseCase>(
        () => _i498.GetPhotosUseCase(gh<_i208.PhotoRepository>()));
    gh.factory<_i115.PhotoCubit>(() => _i115.PhotoCubit(
          gh<_i498.GetPhotosUseCase>(),
          gh<_i208.PhotoRepository>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i785.RegisterModule {}
