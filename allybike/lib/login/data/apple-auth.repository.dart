import 'package:allybike/class/result.class.dart';
import 'package:allybike/login/models/firebase-auth-response.model.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_auth/firebase_auth.dart';

@Injectable(as: IAppleAuthRepository)
class AppleAuthRepository implements IAppleAuthRepository {
  final FirebaseAuth firebaseAuth;
  final AppleAuthProvider appleAuthProvider;

  AppleAuthRepository({
    required this.firebaseAuth,
    required this.appleAuthProvider,
  });
  
  @override
  Future<Result<FireBaseAuthResponse>> signInWithApple() async {
    try {
      appleAuthProvider.addScope('email');
      appleAuthProvider.addScope('name');
      final credentials = await firebaseAuth.signInWithProvider(
        appleAuthProvider,
      );
      return Result(
        data: FireBaseAuthResponse(
          email: credentials.user!.email,
          name: _getDisplayNameOfProviderData(credentials.user!.providerData),
          phone: credentials.user!.phoneNumber,
          uid: credentials.user!.uid,
        ),
      );
    } catch (e) {
       return Result(error: "Ocurrio un error");
    }
  }

  String _getDisplayNameOfProviderData(List<UserInfo>  providerData){
    final userInfo = providerData.firstWhere((e) => e.displayName != null);
    return userInfo.displayName!;
  }
}

abstract class IAppleAuthRepository {
  Future<Result<FireBaseAuthResponse>> signInWithApple();
}
