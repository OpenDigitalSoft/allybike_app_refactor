import 'dart:io';

import 'package:allybike/class/result.class.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class Http {
  final Dio dio;
  final FlutterSecureStorage storage;

  Http({@Named("api") required this.dio, required this.storage}) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await storage.read(key: 'token');
          if (token != null) {
            options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  // Método genérico interno
  Future<Result<T>> _request<T>(Future<Response<T>> Function() apiCall) async {
    try {
      final response = await apiCall();
      return Result<T>(data: response.data);
    } on DioException catch (e) {
      
      Map<DioExceptionType, (ErrorType, String) Function(DioException)>
      errorHandles = {
        DioExceptionType.cancel: (e) =>
            (ErrorType.unknown, "Petición cancelada"),
        DioExceptionType.connectionTimeout: (e) =>
            (ErrorType.network, "Tiempo de conexión agotado"),
        DioExceptionType.sendTimeout: (e) =>
            (ErrorType.network, "Tiempo de envío agotado"),
        DioExceptionType.receiveTimeout: (e) =>
            (ErrorType.network, "Tiempo de respuesta agotado"),
        DioExceptionType.badCertificate: (e) =>
            (ErrorType.unknown, "Certificado inválido"),
        DioExceptionType.connectionError: (e) =>
            (ErrorType.network, "Error de conexión"),
        DioExceptionType.badResponse: _getErrorBadRequest,
        DioExceptionType.unknown: _getErrorUnknown,
      };
      final handler = errorHandles[e.type];
      final (errorType, errorMessage) =
          handler != null ? handler(e) : (ErrorType.unknown, "Error desconocido");
      return Result<T>(error: errorMessage, type: errorType);
    } catch (e) {
      return Result<T>(error: e.toString());
    }
  }

  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request(() => dio.get<T>(path, queryParameters: queryParameters));
  }

  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request(
      () => dio.post<T>(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<Result<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    return _request(
      () => dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: token != null
            ? Options(headers: {"Authorization": "Bearer $token"})
            : null,
      ),
    );
  }

  Future<Result<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request(
      () => dio.delete<T>(path, data: data, queryParameters: queryParameters),
    );
  }

  (ErrorType, String) _getErrorBadRequest(DioException e) {
    if (e.response?.data is Map<String, dynamic> &&
        e.response?.data['message'] != null) {
      return (ErrorType.server, e.response?.data['message']);
    } else {
      return (
        ErrorType.server,
        "Error ${e.response?.statusCode}: ${e.response?.statusMessage}",
      );
    }
  }

  (ErrorType, String) _getErrorUnknown(DioException e) {
    if (e.error is SocketException) {
      return (ErrorType.network, "Sin conexión a Internet");
    } else {
      return (ErrorType.unknown, e.error.toString());
    }
  }
}
