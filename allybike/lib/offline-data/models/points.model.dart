import 'dart:convert';
import 'dart:io';

import 'package:allybike/offline-data/enums/sync-status.enum.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

class PointRouteOffline {
  final int idRoute;
  final int idUser;
  final double distance;
  final List<LatLng> points;
  final SyncStatus syncStatus;
  late File _file;

  File get file => _file;

  PointRouteOffline({
    required this.idRoute,
    required this.idUser,
    required this.distance,
    required this.points,
    this.syncStatus = SyncStatus.pending,
  });

 
  PointRouteOffline copyWith({
    int? idRoute,
    int? idUser,
    double? distance,
    List<LatLng>? points,
    SyncStatus? syncStatus,
  }) {
    return PointRouteOffline(
      idRoute: idRoute ?? this.idRoute,
      idUser: idUser ?? this.idUser,
      distance: distance ?? this.distance,
      points: points ?? this.points,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRoute' : idRoute,
      'idUser': idUser,
      'distance': distance,
      'points': points
          .map((point) => {'latitude': point.latitude, 'longitude': point.longitude})
          .toList(),
    };
  }

  factory PointRouteOffline.fromJson(Map<String, dynamic> json) {
    return PointRouteOffline(
      idRoute: json['idRoute'] as int,
      idUser: json['idUser'] as int,
      distance: json['distance'] as double,
      points: (json['points'] as List)
          .map((point) => LatLng(
                point['latitude'] as double,
                point['longitude'] as double,
              ))
          .toList(),
    );
  }

  Future<void> toFile() async {
     final jsonPoint = toJson();
     final jsonString = jsonEncode(jsonPoint);
     final dir = await getApplicationDocumentsDirectory();
     final file = File('${dir.path}/user_data.json');
     await file.writeAsString(jsonString);
     _file = file;
  }
}
