part of 'error_cubit.dart';

@immutable
sealed class ErrorState {}

final class ErrorInitial extends ErrorState {}

final class ShowError extends ErrorState {
  final String message;
  ShowError({required this.message});
}
