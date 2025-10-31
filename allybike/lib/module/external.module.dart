import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';


@module
abstract class ExternalModule {
  
  @Named("api")
  @lazySingleton
  Dio dio() => Dio(BaseOptions(baseUrl: 'http://10.0.2.2:9000/api/v1'));

  @lazySingleton
  FlutterSecureStorage storage() => const FlutterSecureStorage();

  
  @lazySingleton
  FirebaseAuth authFirebase() => FirebaseAuth.instance;

  @lazySingleton
  GoogleSignIn googleSingIn()  =>  GoogleSignIn.instance;

  @lazySingleton
  AppleAuthProvider appleAuthProvider() => AppleAuthProvider();

  @lazySingleton
  ImagePicker imagePicker() => ImagePicker();

  @lazySingleton
  Connectivity connectivity() => Connectivity();
  
  
}
