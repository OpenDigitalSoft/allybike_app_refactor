
import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IOfflineDataRepository)
class OfflineDataRepository implements IOfflineDataRepository {

  final Http _http;
  OfflineDataRepository({required Http http}) : _http = http;

  @override
  Future<JsonResult> verifyConnectivityApi() async {
    return await _http.get('/ok');
  }

}

abstract class IOfflineDataRepository {
  Future<JsonResult> verifyConnectivityApi();
}