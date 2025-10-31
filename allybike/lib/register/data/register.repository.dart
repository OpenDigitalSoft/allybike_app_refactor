
import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IRegisterRepository)
class RegisterRepository implements IRegisterRepository {

  final Http _http;

  RegisterRepository({required Http http}):_http = http;

  @override
  Future<JsonResult> registerUser(Map<String,dynamic> data) async {
    return await _http.post("/users",data: data);
  }

}

abstract class IRegisterRepository {
  Future<JsonResult> registerUser(Map<String,dynamic> data);
}