part of 'bike_ride_cubit.dart';

@immutable
sealed class BikeRideState {}

final class BikeRideInitial extends BikeRideState {}

final class GetBikeRideLoading extends BikeRideState {}

final class GetBikeRideSuccess extends BikeRideState {
  final List<BikeRide> bikeRideToday;
  final List<BikeRide> bikeRides;
  final bool isFinal;
  final int page;
  GetBikeRideSuccess({
    required this.bikeRideToday,
    required this.bikeRides,
    this.isFinal = false,
    this.page = 0,
  });
}

final class GetBikeRideFailure extends BikeRideState {}
