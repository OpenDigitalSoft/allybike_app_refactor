part of 'set_route_map_cubit.dart';

@immutable
sealed class SetRouteMapState {}

final class SetRouteMapInitial extends SetRouteMapState {}

final class SetPositionCurrent extends SetRouteMapState {
  final Position position;
  final List<LatLng> path;
  final bool isPaused;
  final File? photoRoute;
  final List<SiteOffline> sites;
  final int? idRoute;
  final int? idCalification;
  final double totalDistance;
  SetPositionCurrent({
    required this.position,
    this.path = const [],
    this.isPaused = false,
    this.photoRoute,
    this.sites = const [],
    this.idRoute,
    this.idCalification,
    this.totalDistance = 0.0,
  });

  SetPositionCurrent copyWith({
    Position? position,
    List<LatLng>? path,
    bool? isPaused,
    File? photoRoute,
    List<SiteOffline>? sites,
    int? idRoute,
    int? idCalification,
    double? totalDistance,
  }) {
    return SetPositionCurrent(
      position: position ?? this.position,
      path: path ?? this.path,
      isPaused: isPaused ?? this.isPaused,
      photoRoute: photoRoute ?? this.photoRoute,
      sites: sites ?? this.sites,
      idRoute: idRoute ?? this.idRoute,
      idCalification: idCalification ?? this.idCalification,
      totalDistance: totalDistance ?? this.totalDistance,
    );
  }
}
