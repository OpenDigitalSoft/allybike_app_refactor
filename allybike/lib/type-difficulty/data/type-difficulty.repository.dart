import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ITypeDifficultyRepository)
class TypeDifficultyRepository implements ITypeDifficultyRepository {

  final Http _http;
  TypeDifficultyRepository({required Http http}) : _http = http;

  @override
  Future<JsonListResult> getTypeRoutes() async {
    return await _http.get("/routes/type-difficulty");
  }
}

abstract class ITypeDifficultyRepository {
  Future<JsonListResult> getTypeRoutes();
}

