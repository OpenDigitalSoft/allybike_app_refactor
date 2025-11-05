import 'package:allybike/class/result.class.dart';
import 'package:allybike/login/data/apple-auth.repository.dart';
import 'package:allybike/login/data/google-auth.repository.dart';
import 'package:allybike/login/data/login.repository.dart';
import 'package:allybike/login/models/firebase-auth-response.model.dart';
import 'package:allybike/storage/data/storage.repocitory.dart';
import 'package:allybike/user/models/user.model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'login_state.dart';


abstract class ILoginCubit {
  void login(String email, String password);
  void loginGoogle();
  void loginApple();
  Future<void> verifyToken(User user);
  void logout();
}

@lazySingleton
class LoginCubit extends Cubit<LoginState> implements ILoginCubit {

  final ILoginRepository repository;
  final IStorageRepository storage;
  final IGoogleAuthRepository googleAuthRepository;
  final IAppleAuthRepository appleAuthRepository;

  LoginCubit({
    required this.repository,
    required this.storage,
    required this.googleAuthRepository,
    required this.appleAuthRepository,
  }) : super(LoginInitial());
  
  @override
  login(String email, String password) async {
    emit(LoginLoading());
    final response = await repository.login(email, password);
    final token = response.data?["token"];
    if (response.isError) {
      emit(LoginFailure());
      addError(response.error!);
      return;
    }
    final user = User.fromJson(response.data?["user"]);
    emit(LoginSuccess(token: token,user: user));
    storage.write(key: "token", value: token);
  }
  
  @override
  loginGoogle() async {
    final response = await googleAuthRepository.login();
    final verifyCredential = _verifyCredentialsAuthSocial(response);
    if (!verifyCredential) {
      return;
    }
    final credentials = response.data!;
    login(credentials.email!, credentials.uid!);
  }
  
  @override
  loginApple() async {
    final response = await appleAuthRepository.signInWithApple();
    final verifyCredential = _verifyCredentialsAuthSocial(response);
    if (!verifyCredential) {
      return;
    }
    final credentials = response.data!;
    login(credentials.email!, credentials.uid!);
  }

  @override
  verifyToken(User user) async {
    final token = await storage.read(key: "token");
    if (token != null && token.isNotEmpty) {
      emit(LoginSuccess(token: token,user: user));
    }
  }
  
  @override
  logout() async {
    await storage.deleteAll();
    emit(LoginInitial());
  }

  _verifyCredentialsAuthSocial(Result<FireBaseAuthResponse> response) {
    if (response.isError) {
      emit(LoginFailure());
      addError(response.error!);
      return false;
    }
    final credentials = response.data;
    if (credentials!.email == null || credentials.uid == null) {
      emit(LoginFailure());
      addError("No existen las credenciales");
      return false;
    }
    return true;
  }
}


