part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}


final class GetUserLoading extends UserState {}
final class GetUserSuccess extends UserState {
  final User user;
  GetUserSuccess({required this.user});
}
final class GetUserFailure extends UserState {}


