import 'package:allybike/offline-data/enums/sync-status.enum.dart';


class SiteOffline {
  final int idRoute;
  final int idType;
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
    required this.idType,
    this.syncStatus = SyncStatus.pending,
  });

 SiteOffline copyWith({
    int? idRoute,
    int? idType,
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
      idType: idType ?? this.idType,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idRoute': idRoute,
      'description': description,
      'photo': photo,
      'latitude': latitude,
      'longitude': longitude,
      'idType': idType,
    };
  }

  factory SiteOffline.fromJson(Map<String, dynamic> json) {
    return SiteOffline(
      idRoute: json['idRoute'],
      description: json['description'],
      photo: json['photo'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      idType: json['idType'],
    );
  }
}
