part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String token;
  final User user;
  RegisterSuccess({required this.token, required this.user});
}

final class RegisterFailure extends RegisterState {}
