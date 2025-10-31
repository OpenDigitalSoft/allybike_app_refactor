import 'package:allybike/offline-data/enums/sync-status.enum.dart';
import 'package:dio/dio.dart';

class SiteOffline {
  final int idRoute;
  final String description;
  final String photo;
  final double latitude;
  final double longitude;
  final SyncStatus syncStatus;

  SiteOffline({
    required this.idRoute,
    required this.description,
    required this.photo,
    required this.latitude,
    required this.longitude,
    this.syncStatus = SyncStatus.pending,
  });

 SiteOffline copyWith({
    int? idRoute,
    String? description,
    String? photo,
    double? latitude,
    double? longitude,
    SyncStatus? syncStatus,
  }) {
    return SiteOffline(
      idRoute: idRoute ?? this.idRoute,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    return {
      'idRoute': idRoute,
      'description': description,
      'photo': await MultipartFile.fromFile(
        photo,
        filename: "${DateTime.now().millisecondsSinceEpoch}_${photo.split('/').last}",
      ),
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory SiteOffline.fromJson(Map<String, dynamic> json) {
    return SiteOffline(
      idRoute: json['idRoute'],
      description: json['description'],
      photo: json['photo'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
