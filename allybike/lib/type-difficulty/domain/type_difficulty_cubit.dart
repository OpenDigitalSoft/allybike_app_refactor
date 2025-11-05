import 'package:allybike/type-difficulty/data/type-difficulty.repository.dart';
import 'package:allybike/type-difficulty/model/type-difficulty.model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


part 'type_difficulty_state.dart';

@lazySingleton
class TypeDifficultyCubit extends Cubit<TypeDifficultyState> {

  final ITypeDifficultyRepository repository;
  TypeDifficultyCubit({required this.repository}) : super(TypeDifficultyInitial());
  
  
   getTypeDifficulty() async {
    emit(GetTypeDifficultyLoading());
    final response = await repository.getTypeRoutes();
    if (response.isError) {
      emit(GetTypeDifficultyFailure());
      addError(response.error!);
      return;
    }
    final difficulty = List<TypeDifficulty>.from(
      response.data!.map((x) => TypeDifficulty.fromJson(x)),
    );
    emit(GetTypeDifficultySuccess(difficulty: difficulty));
  }


}
