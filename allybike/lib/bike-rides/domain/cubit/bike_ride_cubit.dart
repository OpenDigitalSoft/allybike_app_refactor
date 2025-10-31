import 'package:allybike/bike-rides/data/bike-rides.repository.dart';
import 'package:allybike/bike-rides/models/bike-ride.model.dart';
import 'package:allybike/class/result.class.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'bike_ride_state.dart';

@lazySingleton
class BikeRideCubit extends Cubit<BikeRideState> {
  final BikeRidesRepository repository;
  BikeRideCubit({required this.repository}) : super(BikeRideInitial());

  getInitialDataBikeRide() async {
    emit(GetBikeRideLoading());
    final (responseToday, responseBikeRide) = await (
      repository.getRoadBikesToday(),
      repository.getRoadBikesByPage(0),
    ).wait;

    final bikeridesToday = _getBikeRideOfResponse(responseToday);
    final bikerides = _getBikeRideOfResponse(responseBikeRide);
    emit(
      GetBikeRideSuccess(bikeRideToday: bikeridesToday, bikeRides: bikerides),
    );
  }

  
  Future<void> getBikeRideByPage(int page) async {
    if(state is GetBikeRideSuccess){
      final bikeRideToday = (state as GetBikeRideSuccess).bikeRideToday;
      final bikeRides = (state as GetBikeRideSuccess).bikeRides;
      final response = await repository.getRoadBikesByPage(page);
      if (response.isError) {
        emit(GetBikeRideFailure());
        emit(GetBikeRideSuccess(bikeRideToday: bikeRideToday, bikeRides: bikeRides));
        addError(response.error!);
        return;
      }
      final newBikeRides = List<BikeRide>.from(
        response.data!.map((x) => BikeRide.fromJson(x)),
      );
        emit(
          GetBikeRideSuccess(
            bikeRides: [...bikeRides, ...newBikeRides],
            bikeRideToday: bikeRideToday,
            page: page,
            isFinal: newBikeRides.isEmpty,
          ),
        );
    }   
  }

  

  List<BikeRide> _getBikeRideOfResponse(Result<List<dynamic>> response){
    if(response.isError){
       emit(GetBikeRideFailure());
       addError(response.error!);
       return [];
    }
    final bikerides = List<BikeRide>.from(
      response.data!.map((x) => BikeRide.fromJson(x)),
    );
    return bikerides;
  }
}
