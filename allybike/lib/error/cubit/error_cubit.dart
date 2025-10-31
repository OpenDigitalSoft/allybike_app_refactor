import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';


part 'error_state.dart';

@lazySingleton
class ErrorCubit extends Cubit<ErrorState> {
  ErrorCubit() : super(ErrorInitial());

  showError(String error){
    emit(ShowError(message: error));
  }
}
