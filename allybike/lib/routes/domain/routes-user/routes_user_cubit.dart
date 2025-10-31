import 'dart:async';

import 'package:allybike/enums/search-state.enum.dart';
import 'package:allybike/routes/data/route.repository.dart';
import 'package:allybike/routes/models/route.model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


part 'routes_user_state.dart';

@lazySingleton
class RoutesUserCubit extends Cubit<RoutesUserState> {

  final RouteRepository repository;
  RoutesUserCubit({required this.repository}) : super(RoutesUserInitial());
  
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }


   getInitialRoutes(int idUser) async {
    emit(GetRoutesOfUserLoading());
    final response = await repository.getRouteOfUserByPage(0,idUser);
    if (response.isError) {
      emit(GetRoutesOfUserFailure());
      emit(GetRoutesOfUserSuccess(routes: []));
      addError(response.error!);
      return;
    }
    final routes = List<AllyBikeRoute>.from(
      response.data!.map((x) => AllyBikeRoute.fromJson(x)),
    );
    emit(GetRoutesOfUserSuccess(routes: routes));
  }

  Future<void> getRoutesByPage(int page,int idUser) async {
    if (page == 0) {
      getInitialRoutes(idUser);
      return;
    }
    final response = await repository.getRouteByPage(page);
    if (response.isError) {
      emit(GetRoutesOfUserFailure());
      emit(GetRoutesOfUserSuccess(routes: [], filterRoutes: [], page: 0));
      addError(response.error!);
      return;
    }
    final routes = List<AllyBikeRoute>.from(
      response.data!.map((x) => AllyBikeRoute.fromJson(x)),
    );
    if (state is GetRoutesOfUserSuccess) {
      final routesSave = (state as GetRoutesOfUserSuccess).routes;
      emit(
        GetRoutesOfUserSuccess(
          routes: [...routesSave, ...routes],
          filterRoutes: [],
          page: page,
          isFinal: routes.isEmpty,
        ),
      );
      return;
    }
  }

   getRouteByText(String text, int idUser) async {
    if (state is! GetRoutesOfUserSuccess) return;
    final currentState = state as GetRoutesOfUserSuccess;
    final routes = currentState.routes;
    final page = currentState.page;
    if (text.length < 3) {
      _emitSuccess(
        routes: routes,
        page: page,
        filterRoutes: [],
        searchState: SearchState.idle,
      );
      return;
    }
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      emit(GetRoutesOfUserLoading());
      final response = await repository.getRoutesOfUserByText(text, idUser);
      if (response.isError) {
        addError(response.error!);
        _emitSuccess(
          routes: routes,
          page: page,
          filterRoutes: [],
          searchState: SearchState.idle,
        );
        return;
      }
      final routesFilter = List<AllyBikeRoute>.from(
        response.data!.map((x) => AllyBikeRoute.fromJson(x)),
      );
      _emitSuccess(
        routes: routes,
        page: page,
        filterRoutes: routesFilter,
        searchState: SearchState.searching,
      );
    });
  }

   getRoutesByFilter({int? idTypeRoute, int? idTypeDifficulty}) async {
    if (state is! GetRoutesOfUserLoading) return;
    final currentState = state as GetRoutesOfUserSuccess;
    final routes = currentState.routes;
    final page = currentState.page;
    emit(GetRoutesOfUserLoading());
    final response = await repository.getRoutesOfUserByFilter(
      idTypeRoute: idTypeRoute,
      idTypeDifficulty: idTypeDifficulty,
    );
    if (response.isError) {
      addError(response.error!);
      _emitSuccess(
        routes: routes,
        page: page,
        filterRoutes: [],
        searchState: SearchState.idle,
      );
      return;
    }
    final routesFilter = List<AllyBikeRoute>.from(
      response.data!.map((x) => AllyBikeRoute.fromJson(x)),
    );
    _emitSuccess(
      routes: routes,
      page: page,
      filterRoutes: routesFilter,
      searchState: SearchState.searching,
    );
  }

  void _emitSuccess({
    required List<AllyBikeRoute> routes,
    required int page,
    required List<AllyBikeRoute> filterRoutes,
    required SearchState searchState,
  }) {
    emit(
      GetRoutesOfUserSuccess(
        routes: routes,
        filterRoutes: filterRoutes,
        page: page,
        searchState: searchState,
      ),
    );
  }
}

