import 'package:allybike/bike-rides/domain/cubit/bike_ride_cubit.dart';
import 'package:allybike/error/cubit/error_cubit.dart';
import 'package:allybike/location/domain/location_cubit.dart';
import 'package:allybike/login/domain/login_cubit.dart';
import 'package:allybike/main.dart';
import 'package:allybike/offline-data/domain/offline_data_cubit.dart';
import 'package:allybike/register/domain/register_cubit.dart';
import 'package:allybike/routes/domain/create-routes/create_route_cubit.dart';
import 'package:allybike/routes/domain/routes-user/routes_user_cubit.dart';
import 'package:allybike/routes/domain/routes/route_cubit.dart';
import 'package:allybike/type-difficulty/domain/type_difficulty_cubit.dart';
import 'package:allybike/type-routes/domain/type_route_cubit.dart';
import 'package:allybike/type-sites/domain/type_site_cubit.dart';
import 'package:allybike/user/domain/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

providers(BuildContext context) {
  return [
     BlocProvider(
       create: (context) =>
           dependencyRegister<LoginCubit>()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<RegisterCubit>()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<UserCubit>()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<BikeRideCubit>()..getInitialDataBikeRide()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<RouteCubit>()..getInitialRoutes()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<RoutesUserCubit>()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<ErrorCubit>()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<TypeRouteCubit>()..getTypeRoutes()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<TypeDifficultyCubit>()..getTypeDifficulty()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<LocationCubit>()..getCityNameByPosition()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<CreateRouteCubit>()
     ),
     BlocProvider(
       create: (context) =>
           dependencyRegister<TypeSiteCubit>()..getTypeSites()
     ),
     BlocProvider(
       lazy: false,
       create: (context) =>
           dependencyRegister<OfflineDataCubit>()..listenToConnectivityChanges()
     ),
  ];
}   