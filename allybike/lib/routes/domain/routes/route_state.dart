part of 'route_cubit.dart';

@immutable
sealed class RouteState {}

final class RouteInitial extends RouteState {}

final class GetRoutesLoading extends RouteState {}

final class GetRoutesSuccess extends RouteState {
  final List<AllyBikeRoute> routes;
  final List<AllyBikeRoute> filterRoutes;
  final int page;
  final bool isFinal;
  final SearchState searchState;
  GetRoutesSuccess({
    required this.routes,
    required this.filterRoutes,
    required this.page,
    this.isFinal = false,
    this.searchState = SearchState.idle,
  });
}

final class GetRoutesFailure extends RouteState {}
