part of 'location_cubit.dart';

@immutable
sealed class LocationState {}

final class LocationInitial extends LocationState {}





/* Obtener Nombre de ciudad */
final class GetLocationDataSuccess extends LocationState {
     final City? city;
     final List<SelectDataCity> listCities;
     GetLocationDataSuccess({ this.city, required this.listCities});
}
final class GetLocationDataFailure extends LocationState {}
final class GetLocationDataLoading extends LocationState {}