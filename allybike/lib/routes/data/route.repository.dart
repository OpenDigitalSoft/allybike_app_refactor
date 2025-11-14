import 'dart:io';

import 'package:allybike/class/http.class.dart';
import 'package:allybike/offline-data/models/difficulty.model.dart';
import 'package:allybike/offline-data/models/image.model.dart';
import 'package:allybike/offline-data/models/points.model.dart';
import 'package:allybike/offline-data/models/site.model.dart';
import 'package:allybike/types/response-json.type.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IRouteRepository)
class RouteRepository implements IRouteRepository {
  final Http _http;

  RouteRepository({required Http http}) : _http = http;

  @override
  Future<JsonListResult> getRouteByPage(int page) async {
    return _http.get("/routes", queryParameters: {"page": page});
  }

  @override
  Future<JsonListResult> getRouteOfUserByPage(int page, int idUser) async {
    return _http.get(
      "/routes/user",
      queryParameters: {"page": page, "idUser": idUser},
    );
  }

  @override
  Future<JsonListResult> getRoutesByText(String text) async {
    return _http.get("/routes/search", queryParameters: {"text": text});
  }

  @override
  Future<JsonListResult> getRoutesOfUserByText(String text, int idUser) async {
    return _http.get(
      "/routes/user/search",
      queryParameters: {"text": text, "idUser": idUser},
    );
  }

  @override
  Future<JsonListResult> getRouteByFilter({
    int? idTypeRoute,
    int? idTypeDifficulty,
  }) async {
    return _http.get(
      "/routes/filter-type",
      queryParameters: {
        "idType": idTypeRoute,
        "idDifficulty": idTypeDifficulty,
      },
    );
  }

  @override
  Future<JsonListResult> getRoutesOfUserByFilter({
    int? idTypeRoute,
    int? idTypeDifficulty,
  }) async {
    return _http.get(
      "/routes/user/filter-type",
      queryParameters: {
        "idType": idTypeRoute,
        "idDifficulty": idTypeDifficulty,
      },
    );
  }

  @override
  Future<JsonResult> createInitialRoute({
    required String name,
    required String descriptions,
    required int idType,
    required int idLocation,
    required int idUser,
  }) async {
    return _http.post(
      "/routes",
      data: {
        "name": name,
        "descriptions": descriptions,
        "idType": idType,
        "idLocation": idLocation,
        "idUser": idUser,
      },
    );
  }

  @override
  Future<JsonListResult> saveSite(SiteOffline site) async {
    return _http.post(
      "/routes/sites",
      data: FormData.fromMap({
        ...site.toJson(),
        "photo": await MultipartFile.fromFile(
          site.photo,
          filename:
              "${DateTime.now().millisecondsSinceEpoch}_${site.photo.split('/').last}",
        ),
      }),
    );
  }

  @override
  Future<JsonListResult> savePoints(PointRouteOffline points) async {
    return _http.post("/routes/points", data: points.toJson());
  }

  @override
  Future<JsonListResult> saveImageRoute(ImageRouteOffline image) async {
    final data = image.toJson();
    return _http.post(
      "/routes/image",
      data: FormData.fromMap({
        "id": data['id'],
        "image": await MultipartFile.fromFile(
          data['image'],
          filename:
              "${data['id']}_${data['image'].split('/').last}",
        ),
      }),
    );
  }

  @override
  Future<JsonResult> updateDifficulty(DifficultyOffline difficulty) {
    return _http.put(
      "/routes/${difficulty.idRoute}",
      data: {"idDifficulty": difficulty.idDifficulty},
    );
  }

  @override
  Future<JsonResult> savePointWithFile(
    PointRouteOffline points,
    int idUser,
    File filePoints,
  ) async {
    return _http.post(
      "/routes/points/file",
      data: FormData.fromMap({
        "idUser": idUser,
        "idRoute": points.idRoute,
        "points": MultipartFile.fromFileSync(
          filePoints.path,
          filename: "points.json",
        ),
      }),
    );
  }
}

abstract class IRouteRepository {
  Future<JsonListResult> getRouteByPage(int page);
  Future<JsonListResult> getRouteOfUserByPage(int page, int idUser);
  Future<JsonListResult> getRoutesByText(String text);
  Future<JsonListResult> getRoutesOfUserByText(String text, int idUser);
  Future<JsonListResult> getRouteByFilter({
    int? idTypeRoute,
    int? idTypeDifficulty,
  });
  Future<JsonListResult> getRoutesOfUserByFilter({
    int? idTypeRoute,
    int? idTypeDifficulty,
  });
  Future<JsonResult> createInitialRoute({
    required String name,
    required String descriptions,
    required int idType,
    required int idLocation,
    required int idUser,
  });
  Future<JsonListResult> saveSite(SiteOffline site);
  Future<JsonListResult> savePoints(PointRouteOffline points);
  Future<JsonResult> savePointWithFile(
    PointRouteOffline points,
    int idUser,
    File filePoints
  );
  Future<JsonListResult> saveImageRoute(ImageRouteOffline image);
  Future<JsonResult> updateDifficulty(DifficultyOffline difficulty);
}
