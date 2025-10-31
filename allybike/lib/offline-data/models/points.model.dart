import 'package:allybike/offline-data/enums/sync-status.enum.dart';
import 'package:latlong2/latlong.dart';

class PointRouteOffline {
  final int idRoute;
  final double distance;
  final List<LatLng> points;
  final SyncStatus syncStatus;

  PointRouteOffline({
    required this.idRoute,
    required this.distance,
    required this.points,
    this.syncStatus = SyncStatus.pending,
  });

 
  PointRouteOffline copyWith({
    int? idRoute,
    double? distance,
    List<LatLng>? points,
    SyncStatus? syncStatus,
  }) {
    return PointRouteOffline(
      idRoute: idRoute ?? this.idRoute,
      distance: distance ?? this.distance,
      points: points ?? this.points,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRoute' : idRoute,
      'distance': distance,
      'points': points
          .map((point) => {'latitude': point.latitude, 'longitude': point.longitude})
          .toList(),
    };
  }

  factory PointRouteOffline.fromJson(Map<String, dynamic> json) {
    return PointRouteOffline(
      idRoute: json['idRoute'] as int,
      distance: json['distance'] as double,
      points: (json['points'] as List)
          .map((point) => LatLng(
                point['latitude'] as double,
                point['longitude'] as double,
              ))
          .toList(),
    );
  }
}
