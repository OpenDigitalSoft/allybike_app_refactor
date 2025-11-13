import 'dart:async';
import 'dart:io';
import 'package:allybike/image-picker/data/image-picker.repository.dart';
import 'package:allybike/location/data/geolocator.repository.dart';
import 'package:allybike/offline-data/models/site.model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:latlong2/latlong.dart';

part 'set_route_map_state.dart';

@injectable
class SetRouteMapCubit extends Cubit<SetRouteMapState> {
  final IImagePickerRepository imagePickerRepository;
  final IGeolocatorRepository geolocatorRepository;

  SetRouteMapCubit({
    required this.imagePickerRepository,
    required this.geolocatorRepository,
  }) : super(SetRouteMapInitial());

  StreamSubscription? _positionSub;
  LatLng? _lastPosition;

  @override
  Future<void> close() {
    _positionSub?.cancel();
    return super.close();
  }

  startTrackingRoute(int idRoute) async {
    _positionSub = _getPositionStream()!.listen((Position position) async {
      final lastPoint = LatLng(position.latitude, position.longitude);
      if (_lastPosition != null) {
        final distance = _calculateDistance(
          lastPoint: _lastPosition!,
          currentPoint: lastPoint,
        );
        if (distance < 1) return;
      }
      _lastPosition = lastPoint;

      if (state is SetPositionCurrent) {
        final currentState = state as SetPositionCurrent;
        final totalDistance = _calculateDistance(
          lastPoint: currentState.position,
          currentPoint: lastPoint,
        );
        final updatedPath = List<LatLng>.from(currentState.path)
          ..add(lastPoint);
        emit(
          currentState.copyWith(
            position: lastPoint,
            path: updatedPath,
            totalDistance: currentState.totalDistance + totalDistance,
          ),
        );
        return;
      }
      emit(SetPositionCurrent(position: lastPoint, idRoute: idRoute));
    });
  }

  setIdCalification(int idCalification) {
    if (state is SetPositionCurrent) {
      final currentState = state as SetPositionCurrent;
      emit(currentState.copyWith(idCalification: idCalification));
    }
  }

  getPhotoRoute() async {
    final hasPermission = await _checkPermissionCamera();
    if (!hasPermission) return;
    final result = await _getPhotoCamera();
    if (result == null) return;
    if (state is SetPositionCurrent) {
      final currentState = state as SetPositionCurrent;
      emit(currentState.copyWith(photoRoute: File(result.path)));
    }
  }

  void pauseTrackingRoute() {
    if (state is SetPositionCurrent) {
      final currentState = state as SetPositionCurrent;
      emit(currentState.copyWith(isPaused: true));
      _positionSub?.pause();
    }
  }

  void resumeTrackingRoute() {
    if (state is SetPositionCurrent) {
      final currentState = state as SetPositionCurrent;
      emit(currentState.copyWith(isPaused: false));
      _positionSub?.resume();
    }
  }

  addSite(SiteOffline site) async {
    if (state is SetPositionCurrent) {
      final currentState = state as SetPositionCurrent;
      emit(currentState.copyWith(sites: [...currentState.sites, site]));
    }
  }

  void stopTrackingRoute() {
    _positionSub?.cancel();
    _positionSub = null;
  }

  addCalification(int calification) {
    if (state is SetPositionCurrent) {
      final currentState = state as SetPositionCurrent;
      emit(currentState.copyWith(idCalification: calification));
    }
  }

  _checkPermissionCamera() async {
    final hasPermission = await imagePickerRepository.requestPermission();
    if (!hasPermission) {
      addError("Permiso denegado para acceder a la cámara");
      return false;
    }
    return true;
  }

  _getPhotoCamera() async {
    final result = await imagePickerRepository.getImageFromCamera();
    if (result == null) {
      addError("No se seleccionó ninguna imagen");
    }
    return result;
  }

  Stream<Position>? _getPositionStream() {
    if (Platform.isAndroid) {
      return geolocatorRepository.getPositionStreamAndroid();
    }
    if (Platform.isIOS) {
      return geolocatorRepository.getPositionStreamIOS();
    }
    return null;
  }

  double _calculateDistance({
    required LatLng lastPoint,
    required LatLng currentPoint,
  }) {
    final distance = const Distance().as(
      LengthUnit.Meter,
      lastPoint,
      currentPoint,
    );
    return distance;
  }
}
