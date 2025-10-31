import 'package:allybike/recovery/data/recovery.repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'recovery_state.dart';

@injectable
class RecoveryCubit extends Cubit<RecoveryState> {
  final RecoveryRepository repository;

  RecoveryCubit({required this.repository}) : super(RecoveryInitial());

  sendCode(String email) async {
    emit(RecoverySendCodeLoading());
    final response = await repository.sendCode(email);
    if (response.isError) {
      emit(RecoverySendCodeFailure());
      addError(response.error!);
      return;
    }
    emit(RecoverySendCodeSuccess(email: email));
  }

  verifyCode(String code) async {
    if (state is RecoverySendCodeSuccess) {
      final email = (state as RecoverySendCodeSuccess).email;
      emit(VerifyCodeLoading());
      final response = await repository.verifyCode(email, code);
      if (response.isError) {
        emit(VerifyCodeFailure());
        addError(response.error!);
        emit(RecoverySendCodeSuccess(email: email));
        return;
      }
      emit(VerifyCodeSuccess(email: email, token: response.data?["token"]));
    }
  }

  updatePassword(String password) async {
    if (state is VerifyCodeSuccess) {
      final email = (state as VerifyCodeSuccess).email;
      final token = (state as VerifyCodeSuccess).token;
      emit(UpdatePasswordLoading());
      final response = await repository.updatePassword(
        email: email,
        password: password,
        token: token,
      );
      if(response.isError){
         emit(UpdatePasswordFailure());
         addError(response.error!);
         emit(VerifyCodeSuccess(email: email, token: token));
         return;
      }
      emit(UpdatePasswordSuccess());
    }
  }
}
