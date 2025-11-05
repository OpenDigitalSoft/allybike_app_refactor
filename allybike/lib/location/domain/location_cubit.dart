import 'package:allybike/location/data/geolocator.repository.dart';
import 'package:allybike/location/data/location.repocitory.dart';
import 'package:allybike/location/models/city.model.dart';
import 'package:allybike/location/models/location.model.dart';
import 'package:allybike/location/models/select-data-city.model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'location_state.dart';

@lazySingleton
class LocationCubit extends Cubit<LocationState> {
  final IGeolocatorRepository geolocatorRepository;
  final ILocationRepository locationRepository;
  LocationCubit({
    required this.geolocatorRepository,
    required this.locationRepository,
  }) : super(LocationInitial());

  Future<void> getCityNameByPosition() async {
    final serviceEnabledOrPermission = await _checkPermission();
    if (!serviceEnabledOrPermission) {
      emit(GetLocationDataFailure());
      addError("Permisos de ubicación denegados.");
      return;
    }
    final positionResult = await geolocatorRepository.getCurrentPosition();
    if (positionResult.isError) {
      emit(GetLocationDataFailure());
      addError(positionResult.error!);
      return;
    }
    final cityResult = await geolocatorRepository.getCityNameByPosition(
      positionResult.data!,
    );
    if (cityResult.isError) {
      emit(GetLocationDataFailure());
      addError(cityResult.error!);
      getAllLocations();
      return;
    }
    if (cityResult.data!.isEmpty) {
      emit(GetLocationDataFailure());
      addError("No se pudo obtener la información de la ubicación.");
      getAllLocations();
      return;
    }
    final placemark = cityResult.data!.where((place) {
      return place.locality != null &&
          place.locality!.isNotEmpty &&
          place.administrativeArea != null &&
          place.administrativeArea!.isNotEmpty;
    }).first;
    if (placemark.locality == null || placemark.administrativeArea == null) {
      emit(GetLocationDataFailure());
      addError("No se pudo obtener el nombre de la ciudad o estado.");
      getAllLocations();
      return;
    }
    final response = await locationRepository.getCityNameByText(
      placemark.locality!.toLowerCase(),
      placemark.administrativeArea!.toLowerCase(),
    );
    if (response.isError) {
      emit(GetLocationDataFailure());
      addError(response.error!);
      getAllLocations();
      return;
    }
    final location = Location.fromJson(response.data!);
    final city = City(
      name: location.city,
      state: location.departement,
      idLocation: location.codeCity,
    );
    emit(GetLocationDataSuccess(city: city, listCities: []));
  }

  Future<void> getAllLocations() async {
    emit(GetLocationDataLoading());
    final response = await locationRepository.getAllLocations();
    if (response.isError) {
      emit(GetLocationDataFailure());
      addError(response.error!);
      return;
    }
    final List<SelectDataCity> listCities = List<SelectDataCity>.from(
      response.data!.map((x) => SelectDataCity.fromJson(x)),
    );
    if (listCities.isEmpty) {
      emit(GetLocationDataFailure());
      addError("No se encontraron ciudades.");
      return;
    }
    emit(GetLocationDataSuccess(listCities: listCities));
  }

  Future<bool> _checkPermission() async {
    final serviceEnabled = await geolocatorRepository.checkServiceLocation();
    if (!serviceEnabled) {
      addError("El servicio de ubicación está deshabilitado.");
      return false;
    }
    final permissionIsDenied = await geolocatorRepository.checkPermission();
    if (!permissionIsDenied) {
      addError("Los permisos de ubicación están denegados.");
      return false;
    }
    return true;
  }
}
