part of 'recovery_cubit.dart';

@immutable
sealed class RecoveryState {}

final class RecoveryInitial extends RecoveryState {}

/* Send Code */
final class RecoverySendCodeLoading extends RecoveryState {}

final class RecoverySendCodeSuccess extends RecoveryState {
  final String email;
  RecoverySendCodeSuccess({required this.email});
}

final class RecoverySendCodeFailure extends RecoveryState {}

/* Verify Code */
final class VerifyCodeLoading extends RecoveryState {}

final class VerifyCodeSuccess extends RecoveryState {
  final String email;
  final String token;
  VerifyCodeSuccess({required this.email, required this.token});
}

final class VerifyCodeFailure extends RecoveryState {}

/* Update Password */
final class UpdatePasswordLoading extends RecoveryState {}

final class UpdatePasswordSuccess extends RecoveryState {}

final class UpdatePasswordFailure extends RecoveryState {}
