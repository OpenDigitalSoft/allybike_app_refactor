import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@injectable
class BikeRidesRepository {

  final Http _http;

  BikeRidesRepository({required Http http}) : _http = http;

  
  Future<JsonListResult> getRoadBikesToday() async {
      return _http.get("/bike-rides/today");
  }

  Future<JsonListResult> getRoadBikesByPage(int page) async {
      return _http.get("/bike-rides",queryParameters: {"page":page});
  }



}