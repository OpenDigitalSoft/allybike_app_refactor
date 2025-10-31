import 'package:allybike/type-routes/data/type-route.repository.dart';
import 'package:allybike/type-routes/model/type-route.model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


part 'type_route_state.dart';

@lazySingleton
class TypeRouteCubit extends Cubit<TypeRouteState> {

  final TypeRouteRepository repository;
  TypeRouteCubit({required this.repository}) : super(TypeRouteInitial());
  

  getTypeRoutes() async {
    emit(GetTypeRouteLoading());
    final response = await repository.getTypeRoutes();
    if (response.isError) {
      emit(GetTypeRouteFailure());
      addError(response.error!);
      return;
    }
    final typeRoutes = List<TypeRoute>.from(
      response.data!.map((x) => TypeRoute.fromJson(x)),
    );
    emit(GetTypeRouteSuccess(typeRoutes: typeRoutes));
  }


}
