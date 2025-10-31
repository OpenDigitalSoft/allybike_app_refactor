import 'package:allybike/offline-data/models/image.model.dart';
import 'package:allybike/offline-data/models/points.model.dart';
import 'package:allybike/offline-data/models/site.model.dart';

class RouteDataOffline {
  final int id;
  final List<SiteOffline> sites;
  final PointRouteOffline pointsRoute;
  final ImageRouteOffline imageRoute;

  RouteDataOffline({
    required this.id,
    required this.sites,
    required this.pointsRoute,
    required this.imageRoute,
  });


  RouteDataOffline copyWith({ 
    int? id,
    List<SiteOffline>? sites,
    PointRouteOffline? pointsRoute,
    ImageRouteOffline? imageRoute,
  }) {
    return RouteDataOffline(
      id: id ?? this.id,
      sites: sites ?? this.sites,
      pointsRoute: pointsRoute ?? this.pointsRoute,
      imageRoute: imageRoute ?? this.imageRoute,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sites': sites.map((site) => site.toJson()).toList(),
      'pointsRoute': pointsRoute.toJson(),
      'imageRoute': imageRoute.toJson(),
    };
  }

  factory RouteDataOffline.fromJson(Map<String, dynamic> json) {
    return RouteDataOffline(
      id: json['id'] as int,
      sites: (json['sites'] as List<dynamic>)
          .map((site) => SiteOffline.fromJson(site as Map<String, dynamic>))
          .toList(),
      pointsRoute: PointRouteOffline.fromJson(
        json['pointsRoute'] as Map<String, dynamic>,
      ),
      imageRoute: ImageRouteOffline.fromJson(
        json['imageRoute'] as Map<String, dynamic>,
      ),
    );
  }
}
