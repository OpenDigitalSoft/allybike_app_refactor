
import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ILoginRepository)
class LoginRepository implements ILoginRepository {
  final Http _http;

  LoginRepository({required Http http}) : _http = http;
  
  @override
  Future<JsonResult> login(String email, String password) async {
     return  await _http.post("/auth/login", data: {
       "email": email,
       "password": password
     });
   }
}


abstract class ILoginRepository {
  Future<JsonResult> login(String email, String password);
}
