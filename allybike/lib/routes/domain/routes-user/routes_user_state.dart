part of 'routes_user_cubit.dart';

@immutable
sealed class RoutesUserState {}

final class RoutesUserInitial extends RoutesUserState {}


final class GetRoutesOfUserLoading extends RoutesUserState {}
final class GetRoutesOfUserSuccess extends RoutesUserState {
  final List<AllyBikeRoute> routes;
  final int page;
  final List<AllyBikeRoute> filterRoutes;
  final SearchState searchState;  
  final bool isFinal;
  
  GetRoutesOfUserSuccess({
    required this.routes,
    this.page = 0,
    this.filterRoutes = const [],
    this.searchState = SearchState.idle,
    this.isFinal = false,
  });

}
final class GetRoutesOfUserFailure extends RoutesUserState {}



