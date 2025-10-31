import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IRecoveryRepository)
class RecoveryRepository implements IRecoveryRepository {
  final Http _http;

  RecoveryRepository({required Http http}) : _http = http;

  @override
  Future<JsonResult> sendCode(String email) async {
    return _http.put("/users/send-code", data: {"email": email});
  }

  @override
  Future<JsonResult> verifyCode(String email, String code) async {
    return _http.post(
      "/users/verify-code",
      data: {"email": email, "code": code},
    );
  }

  @override
  Future<JsonResult> updatePassword({
    required String email,
    required String password,
    required String token,
  }) async {
    return _http.put(
      "/users/recovery",
      data: {"email": email, "password": password},
      token: token,
    );
  }
}

abstract class IRecoveryRepository {
  Future<JsonResult> sendCode(String email);
  Future<JsonResult> verifyCode(String email, String code);
  Future<JsonResult> updatePassword({
    required String email,
    required String password,
    required String token,
  });
}
