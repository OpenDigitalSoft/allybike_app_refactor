part of 'type_difficulty_cubit.dart';

@immutable
sealed class TypeDifficultyState {}

final class TypeDifficultyInitial extends TypeDifficultyState {}

final class GetTypeDifficultyLoading extends TypeDifficultyState {}
final class GetTypeDifficultySuccess extends TypeDifficultyState {
  final List<TypeDifficulty> difficulty;
  GetTypeDifficultySuccess({required this.difficulty});
}
final class GetTypeDifficultyFailure extends TypeDifficultyState {}
