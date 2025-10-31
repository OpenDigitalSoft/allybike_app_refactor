part of 'create_route_cubit.dart';

@immutable
sealed class CreateRouteState {}

final class CreateRouteInitial extends CreateRouteState {}

final class CreateRouteInitialLoading extends CreateRouteState {}

final class CreateRouteInitialSuccess extends CreateRouteState {
  final int idRoute;
  final String nameRoute;
  CreateRouteInitialSuccess({required this.idRoute, required this.nameRoute});
}

final class CreateRouteInitialFailure extends CreateRouteState {}






