// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:allybike/bike-rides/data/bike-rides.repository.dart' as _i295;
import 'package:allybike/bike-rides/domain/cubit/bike_ride_cubit.dart' as _i497;
import 'package:allybike/class/bloc_observer.dart' as _i824;
import 'package:allybike/class/http.class.dart' as _i521;
import 'package:allybike/error/cubit/error_cubit.dart' as _i715;
import 'package:allybike/image-picker/data/image-picker.repository.dart'
    as _i24;
import 'package:allybike/image-picker/domain/image_picker_cubit.dart' as _i436;
import 'package:allybike/location/data/geolocator.repository.dart' as _i315;
import 'package:allybike/location/data/location.repocitory.dart' as _i420;
import 'package:allybike/location/domain/location_cubit.dart' as _i947;
import 'package:allybike/login/data/apple-auth.repository.dart' as _i568;
import 'package:allybike/login/data/google-auth.repository.dart' as _i946;
import 'package:allybike/login/data/login.repository.dart' as _i876;
import 'package:allybike/login/domain/login_cubit.dart' as _i306;
import 'package:allybike/module/external.module.dart' as _i95;
import 'package:allybike/offline-data/data/offline_data.repository.dart'
    as _i488;
import 'package:allybike/offline-data/domain/offline_data_cubit.dart' as _i749;
import 'package:allybike/recovery/data/recovery.repository.dart' as _i141;
import 'package:allybike/recovery/domain/recovery_cubit.dart' as _i719;
import 'package:allybike/register/data/register.repository.dart' as _i743;
import 'package:allybike/register/domain/register_cubit.dart' as _i854;
import 'package:allybike/routes/data/route.repository.dart' as _i281;
import 'package:allybike/routes/domain/create-routes/create_route_cubit.dart'
    as _i986;
import 'package:allybike/routes/domain/routes-user/routes_user_cubit.dart'
    as _i398;
import 'package:allybike/routes/domain/routes/route_cubit.dart' as _i820;
import 'package:allybike/routes/domain/set-route-map/set_route_map_cubit.dart'
    as _i716;
import 'package:allybike/type-difficulty/data/type-difficulty.repository.dart'
    as _i709;
import 'package:allybike/type-difficulty/domain/type_difficulty_cubit.dart'
    as _i702;
import 'package:allybike/type-routes/data/type-route.repository.dart' as _i444;
import 'package:allybike/type-routes/domain/type_route_cubit.dart' as _i322;
import 'package:allybike/type-sites/data/type-sites.repository.dart' as _i636;
import 'package:allybike/type-sites/domain/type_site_cubit.dart' as _i968;
import 'package:allybike/user/domain/user_cubit.dart' as _i154;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:google_sign_in/google_sign_in.dart' as _i116;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final externalModule = _$ExternalModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => externalModule.storage(),
    );
    gh.lazySingleton<_i59.FirebaseAuth>(() => externalModule.authFirebase());
    gh.lazySingleton<_i116.GoogleSignIn>(() => externalModule.googleSingIn());
    gh.lazySingleton<_i59.AppleAuthProvider>(
      () => externalModule.appleAuthProvider(),
    );
    gh.lazySingleton<_i183.ImagePicker>(() => externalModule.imagePicker());
    gh.lazySingleton<_i895.Connectivity>(() => externalModule.connectivity());
    gh.lazySingleton<_i154.UserCubit>(() => _i154.UserCubit());
    gh.lazySingleton<_i715.ErrorCubit>(() => _i715.ErrorCubit());
    gh.lazySingleton<_i749.OfflineDataCubit>(
      () => _i749.OfflineDataCubit(
        routeRepository: gh<_i281.RouteRepository>(),
        offlineDataRepository: gh<_i488.OfflineDataRepository>(),
        connectivity: gh<_i895.Connectivity>(),
      ),
    );
    gh.factory<_i946.IGoogleAuthRepository>(
      () => _i946.GoogleAuthRepository(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        googleSignIn: gh<_i116.GoogleSignIn>(),
      ),
    );
    gh.lazySingleton<_i702.TypeDifficultyCubit>(
      () => _i702.TypeDifficultyCubit(
        repository: gh<_i709.TypeDifficultyRepository>(),
      ),
    );
    gh.factory<_i568.IAppleAuthRepository>(
      () => _i568.AppleAuthRepository(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
        appleAuthProvider: gh<_i59.AppleAuthProvider>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => externalModule.dio(),
      instanceName: 'api',
    );
    gh.factory<_i719.RecoveryCubit>(
      () => _i719.RecoveryCubit(repository: gh<_i141.RecoveryRepository>()),
    );
    gh.factory<_i315.IGeolocatorRepository>(() => _i315.GeolocatorRepository());
    gh.lazySingleton<_i968.TypeSiteCubit>(
      () => _i968.TypeSiteCubit(
        typeSitesRepository: gh<_i636.TypeSitesRepository>(),
      ),
    );
    gh.lazySingleton<_i947.LocationCubit>(
      () => _i947.LocationCubit(
        geolocatorRepository: gh<_i315.GeolocatorRepository>(),
        locationRepository: gh<_i420.LocationRepository>(),
      ),
    );
    gh.lazySingleton<_i521.Http>(
      () => _i521.Http(
        dio: gh<_i361.Dio>(instanceName: 'api'),
        storage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i876.ILoginRepository>(
      () => _i876.LoginRepository(http: gh<_i521.Http>()),
    );
    gh.factory<_i636.ITypeSitesRepository>(
      () => _i636.TypeSitesRepository(http: gh<_i521.Http>()),
    );
    gh.lazySingleton<_i986.CreateRouteCubit>(
      () =>
          _i986.CreateRouteCubit(routeRepository: gh<_i281.RouteRepository>()),
    );
    gh.factory<_i24.IImagePickerRepository>(
      () => _i24.ImagePickerRepository(imagePicker: gh<_i183.ImagePicker>()),
    );
    gh.lazySingleton<_i322.TypeRouteCubit>(
      () => _i322.TypeRouteCubit(repository: gh<_i444.TypeRouteRepository>()),
    );
    gh.factory<_i709.ITypeDifficultyRepository>(
      () => _i709.TypeDifficultyRepository(http: gh<_i521.Http>()),
    );
    gh.factory<_i420.ILocationRepository>(
      () => _i420.LocationRepository(http: gh<_i521.Http>()),
    );
    gh.factory<_i436.ImagePickerCubit>(
      () => _i436.ImagePickerCubit(
        imagePickerRepository: gh<_i24.ImagePickerRepository>(),
      ),
    );
    gh.lazySingleton<_i306.LoginCubit>(
      () => _i306.LoginCubit(
        repository: gh<_i876.ILoginRepository>(),
        storage: gh<_i558.FlutterSecureStorage>(),
        googleAuthRepository: gh<_i946.IGoogleAuthRepository>(),
        appleAuthRepository: gh<_i568.IAppleAuthRepository>(),
      ),
    );
    gh.factory<_i854.RegisterCubit>(
      () => _i854.RegisterCubit(
        repository: gh<_i743.RegisterRepository>(),
        storage: gh<_i558.FlutterSecureStorage>(),
        googleAuthRepository: gh<_i946.GoogleAuthRepository>(),
        appleAuthRepository: gh<_i568.AppleAuthRepository>(),
      ),
    );
    gh.lazySingleton<_i398.RoutesUserCubit>(
      () => _i398.RoutesUserCubit(repository: gh<_i281.RouteRepository>()),
    );
    gh.lazySingleton<_i820.RouteCubit>(
      () => _i820.RouteCubit(repository: gh<_i281.RouteRepository>()),
    );
    gh.singleton<_i824.BlocObserverData>(
      () => _i824.BlocObserverData(errorCubit: gh<_i715.ErrorCubit>()),
    );
    gh.factory<_i716.SetRouteMapCubit>(
      () => _i716.SetRouteMapCubit(
        imagePickerRepository: gh<_i24.ImagePickerRepository>(),
        geolocatorRepository: gh<_i315.GeolocatorRepository>(),
      ),
    );
    gh.factory<_i743.IRegisterRepository>(
      () => _i743.RegisterRepository(http: gh<_i521.Http>()),
    );
    gh.factory<_i141.IRecoveryRepository>(
      () => _i141.RecoveryRepository(http: gh<_i521.Http>()),
    );
    gh.factory<_i488.IOfflineDataRepository>(
      () => _i488.OfflineDataRepository(http: gh<_i521.Http>()),
    );
    gh.factory<_i444.ITypeRouteRepository>(
      () => _i444.TypeRouteRepository(http: gh<_i521.Http>()),
    );
    gh.factory<_i281.IRouteRepository>(
      () => _i281.RouteRepository(http: gh<_i521.Http>()),
    );
    gh.factory<_i295.BikeRidesRepository>(
      () => _i295.BikeRidesRepository(http: gh<_i521.Http>()),
    );
    gh.lazySingleton<_i497.BikeRideCubit>(
      () => _i497.BikeRideCubit(repository: gh<_i295.BikeRidesRepository>()),
    );
    return this;
  }
}

class _$ExternalModule extends _i95.ExternalModule {}
