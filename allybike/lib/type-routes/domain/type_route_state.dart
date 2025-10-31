part of 'type_route_cubit.dart';

@immutable
sealed class TypeRouteState {}

final class TypeRouteInitial extends TypeRouteState {}

final class GetTypeRouteLoading extends TypeRouteState {}
final class GetTypeRouteSuccess extends TypeRouteState {
  final List<TypeRoute> typeRoutes;
  GetTypeRouteSuccess({required this.typeRoutes});
}
final class GetTypeRouteFailure extends TypeRouteState {}
