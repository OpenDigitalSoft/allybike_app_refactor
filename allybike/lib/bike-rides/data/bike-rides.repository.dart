import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IBikeRidesRepository)
class BikeRidesRepository implements IBikeRidesRepository {

  final Http _http;

  BikeRidesRepository({required Http http}) : _http = http;

  @override
  Future<JsonListResult> getRoadBikesToday() async {
      return _http.get("/bike-rides/today");
  }

  @override
  Future<JsonListResult> getRoadBikesByPage(int page) async {
      return _http.get("/bike-rides",queryParameters: {"page":page});
  }

}

abstract class IBikeRidesRepository {
  Future<JsonListResult> getRoadBikesToday();
  Future<JsonListResult> getRoadBikesByPage(int page);
}