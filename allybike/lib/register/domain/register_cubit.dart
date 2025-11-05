import 'package:allybike/login/data/apple-auth.repository.dart';
import 'package:allybike/login/data/google-auth.repository.dart';
import 'package:allybike/register/data/register.repository.dart';
import 'package:allybike/register/models/register-user.model.dart';
import 'package:allybike/storage/data/storage.repocitory.dart';
import 'package:allybike/user/models/user.model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {

  final IRegisterRepository repository;
  final IStorageRepository storage;
  final IGoogleAuthRepository googleAuthRepository;
  final IAppleAuthRepository appleAuthRepository;
  RegisterCubit({
    required this.repository,
    required this.storage,
    required this.googleAuthRepository,
    required this.appleAuthRepository
  }) : super(RegisterInitial());

  registerUser(RegisterUserRequest request) async {
    emit(RegisterLoading());
    final data = request.toJson();
    final response = await repository.registerUser(data);
    if (response.isError) {
      emit(RegisterFailure());
      addError(response.error!);
      return;
    }
    final token = response.data?["token"];
    storage.write(key: "token", value: token);
    final user = User.fromJson(response.data?["user"]);
    emit(RegisterSuccess(token: token,user: user));
  }

  registerGoogleUser() async {
    final response = await googleAuthRepository.login();
    if (response.isError) {
      emit(RegisterFailure());
      addError(response.error!);
      return;
    }
    final credentials = response.data;
    if (credentials!.email == null ||
        credentials.uid == null ||
        credentials.name == null) {
      emit(RegisterFailure());
      addError("No existen las credenciales");
      return;
    }
    final userRegiter = RegisterUserRequest(
      email: credentials.email!,
      name: credentials.name!,
      password: credentials.uid!,
      phone: credentials.phone,
    );
    registerUser(userRegiter);
  }

  registerAppleUser() async {
    final response = await appleAuthRepository.signInWithApple();
    if (response.isError) {
      emit(RegisterFailure());
      addError(response.error!);
      return;
    }
    final credentials = response.data;
    if (credentials!.email == null ||
        credentials.uid == null ||
        credentials.name == null) {
      emit(RegisterFailure());
      addError("No existen las credenciales");
      return;
    }
    final userRegiter = RegisterUserRequest(
      email: credentials.email!,
      name: credentials.name!,
      password: credentials.uid!,
      phone: credentials.phone,
    );
    registerUser(userRegiter);
  }
}
