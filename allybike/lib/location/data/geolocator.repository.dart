import 'package:allybike/class/result.class.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IGeolocatorRepository)
class GeolocatorRepository implements IGeolocatorRepository {

  @override
  Future<Result<List<Placemark>>> getCityNameByPosition(
    Position position,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      return Result(data: placemarks);
    } catch (e) {
      return Result(error: e.toString());
    }
  }

  @override
  Future<bool> checkServiceLocation() async {
    try {
      return await Geolocator.isLocationServiceEnabled();
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> checkPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        return true;
      }
      final getPermission = await Geolocator.requestPermission();
      if (getPermission == LocationPermission.always ||
          getPermission == LocationPermission.whileInUse) {
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  @override
  Future<Result<Position>> getCurrentPosition() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: AndroidSettings(
          accuracy: LocationAccuracy.high,
          forceLocationManager: true,
          foregroundNotificationConfig: ForegroundNotificationConfig(
            notificationTitle: "Allybike",
            notificationText:
                "Allybike está utilizando la ubicación en segundo plano",
            enableWakeLock: true,
          ),
        ),
      );
      return Result(data: position);
    } catch (e) {
      return Result(error: e.toString());
    }
  }
  
  @override
  Stream<Position> getPositionStreamAndroid() {
    return Geolocator.getPositionStream(
      locationSettings: _getAndroidSettings(),
    );
  }

  @override
  Stream<Position> getPositionStreamIOS() {
    return Geolocator.getPositionStream(locationSettings: _getAppleSettings());
  }
  
  @override
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  AppleSettings _getAppleSettings() {
    return AppleSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
      pauseLocationUpdatesAutomatically: false,
      activityType: ActivityType.fitness,
      allowBackgroundLocationUpdates: true,
      showBackgroundLocationIndicator: true,
    );
  }

  AndroidSettings _getAndroidSettings() {
    return AndroidSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 2,
      forceLocationManager: true,
      foregroundNotificationConfig: ForegroundNotificationConfig(
        notificationText:
            "Allybike está utilizando la ubicación en segundo plano",
        notificationTitle: "Ejecutándose en segundo plano",
        enableWakeLock: true,
      ),
    );
  }
}

abstract class IGeolocatorRepository {
  Future<Result<List<Placemark>>> getCityNameByPosition(
    Position position,
  );
  Future<bool> checkServiceLocation();
  Future<bool> checkPermission();
  Future<Result<Position>> getCurrentPosition();
  Stream<Position> getPositionStreamAndroid();
  Stream<Position> getPositionStreamIOS();
  double calculateDistance({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
}
