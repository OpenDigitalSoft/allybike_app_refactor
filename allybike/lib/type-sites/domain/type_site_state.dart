part of 'type_site_cubit.dart';

@immutable
sealed class TypeSiteState {}

final class TypeSiteInitial extends TypeSiteState {}

final class GetTypeSitesLoading extends TypeSiteState {}
final class GetTypeSitesSuccess extends TypeSiteState {
  final List<TypeSite> typeSites;
  GetTypeSitesSuccess({required this.typeSites});
}
final class GetTypeSitesFailure extends TypeSiteState {}
