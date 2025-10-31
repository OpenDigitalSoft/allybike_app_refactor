import 'package:allybike/class/result.class.dart';
import 'package:allybike/login/models/firebase-auth-response.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IGoogleAuthRepository)
class GoogleAuthRepository implements IGoogleAuthRepository {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;

  GoogleAuthRepository({
    required this.firebaseAuth,
    required this.googleSignIn,
  });

  @override
  Future<Result<FireBaseAuthResponse>> login() async {
    try {
      await googleSignIn.initialize(serverClientId: "122656271145-3lcto9sidko4fh5bm5gj9cgpgeacgfuj.apps.googleusercontent.com");
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(

        idToken: googleAuth.idToken,
      );
      final credencial = await firebaseAuth.signInWithCredential(credential);
      final response = FireBaseAuthResponse(
        email: credencial.user!.email,
        uid: credencial.user!.uid,
        name: _getDisplayNameOfProviderData(credencial.user!.providerData),
        phone: credencial.user!.phoneNumber,
      );
      return Result(data: response);
    } on GoogleSignInException catch (e) {
      const errorMessages = {
        GoogleSignInExceptionCode.canceled: "El usuario ha cancelado",
        GoogleSignInExceptionCode.clientConfigurationError:
            "Error en la configuración del usuario",
        GoogleSignInExceptionCode.interrupted: "La operación fue interrumpida",
        GoogleSignInExceptionCode.providerConfigurationError:
            "Error en la configuración del proveedor",
        GoogleSignInExceptionCode.uiUnavailable:
            "Error al mostrar la pantalla de inicio",
        GoogleSignInExceptionCode.unknownError: "Error desconocido",
        GoogleSignInExceptionCode.userMismatch: "Error por parte del usuario",
      };
      return Result(error: errorMessages[e.code] ?? "Error desconocido");
    }
  }

  String _getDisplayNameOfProviderData(List<UserInfo> providerData) {
    final userInfo = providerData.firstWhere((e) => e.displayName != null);
    return userInfo.displayName!;
  }
}

abstract class IGoogleAuthRepository {
  Future<Result<FireBaseAuthResponse>> login();
}
