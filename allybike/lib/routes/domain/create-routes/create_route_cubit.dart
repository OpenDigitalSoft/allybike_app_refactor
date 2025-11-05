import 'package:allybike/routes/data/route.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'create_route_state.dart';

@lazySingleton
class CreateRouteCubit extends Cubit<CreateRouteState> {

  final IRouteRepository routeRepository;
  CreateRouteCubit({required this.routeRepository})
    : super(CreateRouteInitial());

 

  createInitialRoute({
    required String name,
    required String descriptions,
    required int idType,
    required int idLocation,
    required int idUser,
  }) async {
    emit(CreateRouteInitialLoading());
    final result = await routeRepository.createInitialRoute(
      name: name,
      descriptions: descriptions,
      idType: idType,
      idLocation: idLocation,
      idUser: idUser,
    );
    if (result.isError) {
      emit(CreateRouteInitialFailure());
      addError(result.error!);
      return;
    }
    emit(
      CreateRouteInitialSuccess(
        idRoute: result.data!['id'],
        nameRoute: result.data!['name'],
      ),
    );
  }


 
}
