import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ITypeRouteRepository)
class TypeRouteRepository implements ITypeRouteRepository {

  final Http _http;
  TypeRouteRepository({required Http http}) : _http = http;

  @override
  Future<JsonListResult> getTypeRoutes() async {
    return await _http.get("/routes/type-route");
  }
}

abstract class ITypeRouteRepository {
  Future<JsonListResult> getTypeRoutes();
}

