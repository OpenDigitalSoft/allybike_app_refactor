import 'package:allybike/class/http.class.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ILocationRepository)
class LocationRepository implements ILocationRepository {
  final Http _http;
  LocationRepository({required Http http}) : _http = http;

  @override
  Future<JsonResult> getCityNameByText(
    String nameCity,
    String nameDepartament,
  ) {
    return _http.get(
      "/locations/city/name",
      queryParameters: {
        "nameCity": nameCity,
        "nameDepartament": nameDepartament,
      },
    );
  }

  @override
  Future<JsonListResult> getAllLocations() {
    return _http.get("/locations/departament/city");
  }
}

abstract class ILocationRepository {
  Future<JsonResult> getCityNameByText(String nameCity, String nameDepartament);
  Future<JsonListResult> getAllLocations();
}
