

import 'package:allybike/home/views/home.view.dart';
import 'package:allybike/login/views/login.view.dart';
import 'package:allybike/main.dart';
import 'package:allybike/recovery/domain/recovery_cubit.dart';
import 'package:allybike/recovery/views/recovery.view.dart';
import 'package:allybike/register/views/register.view.dart';
import 'package:allybike/routes/domain/set-route-map/set_route_map_cubit.dart';
import 'package:allybike/routes/views/create-map-points-route.view.dart';
import 'package:allybike/routes/views/create-route.view.dart';
import 'package:allybike/routes/views/routes-user.view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

routes(BuildContext context) {
  return {
    LoginView.route             : (context) => const LoginView(),
    HomeView.route              : (context) => const HomeView(),
    RegisterView.route          : (context) => const RegisterView(),
    RoutesUserView.route        : (context) => const RoutesUserView(),
    CreateRouteView.route       : (context) => const CreateRouteView(),
    CreateMapPointsRoutes.route : (context) => BlocProvider(
                                   create: (context) => dependencyRegister<SetRouteMapCubit>(),
                                   child: const CreateMapPointsRoutes(),
    ),
    RecoveryView.route          : (context) => BlocProvider(
                                               create: (context) => dependencyRegister<RecoveryCubit>(),
                                               child: RecoveryView(),
                                              ),
  
   };
} 