import 'package:allybike/offline-data/enums/sync-status.enum.dart';

class ImageRouteOffline {
  final int idRoute;
  final String imagePath;
  final SyncStatus syncStatus;

  ImageRouteOffline({
    required this.idRoute,
    required this.imagePath,
    this.syncStatus = SyncStatus.pending,
  });

  copyWith({
    int? idRoute,
    String? imagePath,
    SyncStatus? syncStatus,
  }) {
    return ImageRouteOffline(
      idRoute: idRoute ?? this.idRoute,
      imagePath: imagePath ?? this.imagePath,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': idRoute,
      'image': imagePath,
    };
  }

  factory ImageRouteOffline.fromJson(Map<String, dynamic> json) {
    return ImageRouteOffline(
      idRoute: json['id'] as int,
      imagePath: json['image'] as String,
    );
  }
}
