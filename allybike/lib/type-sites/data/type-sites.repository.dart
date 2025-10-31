import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ITypeSitesRepository)
class TypeSitesRepository implements ITypeSitesRepository {
  final Http _http;
  TypeSitesRepository({required Http http}) : _http = http;

  @override
  Future<JsonListResult> getTypeSites() async {
    return await _http.get("/routes/type-sites");
  }
}

abstract class ITypeSitesRepository {
  Future<JsonListResult> getTypeSites();
}
