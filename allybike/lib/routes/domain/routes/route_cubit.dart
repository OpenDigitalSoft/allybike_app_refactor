import 'dart:async';

import 'package:allybike/enums/search-state.enum.dart';
import 'package:allybike/routes/data/route.repository.dart';
import 'package:allybike/routes/models/route.model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'route_state.dart';

@lazySingleton
class RouteCubit extends Cubit<RouteState>  {

  final IRouteRepository repository;
  RouteCubit({required this.repository}) : super(RouteInitial());

  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> getRoutesByPage(int page) async {
    if (page == 0) {
      getInitialRoutes();
      return;
    }
    if(state is GetRoutesSuccess && (state as GetRoutesSuccess).isFinal){
      return;
    }
    final response = await repository.getRouteByPage(page);
    if (response.isError) {
      emit(GetRoutesFailure());
      emit(GetRoutesSuccess(routes: [], filterRoutes: [], page: 0));
      addError(response.error!);
      return;
    }
    final routes = List<AllyBikeRoute>.from(
      response.data!.map((x) => AllyBikeRoute.fromJson(x)),
    );
    if (state is GetRoutesSuccess) {
      final routesSave = (state as GetRoutesSuccess).routes;
      emit(
        GetRoutesSuccess(
          routes: [...routesSave, ...routes],
          filterRoutes: [],
          page: page,
          isFinal: routes.isEmpty,
        ),
      );
      return;
    }
  }

  getInitialRoutes() async {
    emit(GetRoutesLoading());
    final response = await repository.getRouteByPage(0);
    if (response.isError) {
      emit(GetRoutesFailure());
      emit(GetRoutesSuccess(routes: [], filterRoutes: [], page: 0));
      addError(response.error!);
      return;
    }
    final routes = List<AllyBikeRoute>.from(
      response.data!.map((x) => AllyBikeRoute.fromJson(x)),
    );
    emit(GetRoutesSuccess(routes: routes, filterRoutes: [], page: 0));
  }

  getRouteByText(String text) async {
    if (state is! GetRoutesSuccess) return;
    final currentState = state as GetRoutesSuccess;
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
      emit(GetRoutesLoading());
      final response = await repository.getRoutesByText(text);
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

  getRoutesByFilter({
    int? idTypeRoute,
    int? idTypeDifficulty,
  }) async {
    if (state is! GetRoutesSuccess) return;
    final currentState = state as GetRoutesSuccess;
    final routes = currentState.routes;
    final page = currentState.page;
    emit(GetRoutesLoading());
    final response = await repository.getRouteByFilter(
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
      GetRoutesSuccess(
        routes: routes,
        filterRoutes: filterRoutes,
        page: page,
        searchState: searchState,
      ),
    );
  }
}
