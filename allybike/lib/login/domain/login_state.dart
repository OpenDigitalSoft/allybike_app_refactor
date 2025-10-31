part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;
  final User user;
  LoginSuccess({required this.token, required this.user});
}

class LoginFailure extends LoginState {}
