import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:motqin/core/storage/secure_storage.dart';
import 'package:motqin/core/network/api_endpoints.dart';
import 'package:motqin/core/network/api_exception.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    // Injects Bearer token on every request + handles 401 auto-refresh
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await SecureStorage.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          final refreshed = await _tryRefreshToken();
          if (refreshed) {
            final token = await SecureStorage.getToken();
            error.requestOptions.headers['Authorization'] = 'Bearer $token';
            final response = await _dio.fetch(error.requestOptions);
            return handler.resolve(response);
          }
        }
        handler.next(error);
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (o) => debugPrint(o.toString()),
      ));
    }
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.post(path, data: data, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> delete(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.delete(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await SecureStorage.getRefreshToken();
      final token = await SecureStorage.getToken();
      if (refreshToken == null || token == null) return false;

      final response = await _dio.post(
        ApiEndpoints.refreshToken,
        data: {'token': token, 'refreshToken': refreshToken},
      );

      final newToken = response.data['token'];
      final newRefresh = response.data['refreshToken'];
      if (newToken != null) await SecureStorage.saveToken(newToken);
      if (newRefresh != null) await SecureStorage.saveRefreshToken(newRefresh);
      return true;
    } catch (_) {
      await SecureStorage.clearAll();
      return false;
    }
  }

  ApiException _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] ??
        e.response?.data?['title'] ??
        e.message ??
        'Unknown error';
    return ApiException(message: message.toString(), statusCode: statusCode);
  }
}
