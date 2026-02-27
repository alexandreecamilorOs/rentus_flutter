import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import 'api_exceptions.dart';
import 'token_storage.dart';

class ApiClient {
  ApiClient({
    required TokenStorage tokenStorage,
    Future<String?> Function()? onRefreshToken,
    Dio? dio,
  })  : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConstants.baseUrl)),
        _tokenStorage = tokenStorage,
        _onRefreshToken = onRefreshToken {
    _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final stored = await _tokenStorage.readAccessToken();
          final token = stored?.isNotEmpty == true ? stored : ApiConstants.demoJwt;
          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          final statusCode = e.response?.statusCode;
          final message = e.response?.data is Map<String, dynamic>
              ? (e.response?.data['message']?.toString() ?? e.message)
              : e.message;

          if (statusCode == 401 && _onRefreshToken != null && e.requestOptions.extra['retried'] != true) {
            try {
              final newToken = await _onRefreshToken!();
              if (newToken != null && newToken.isNotEmpty) {
                final retryOptions = e.requestOptions;
                retryOptions.headers['Authorization'] = 'Bearer $newToken';
                retryOptions.extra['retried'] = true;
                final retryResponse = await _dio.fetch(retryOptions);
                handler.resolve(retryResponse);
                return;
              }
            } catch (_) {
              // cae al manejo estándar
            }
          }

          if (statusCode == 401) {
            handler.reject(DioException(requestOptions: e.requestOptions, error: UnauthorizedException(message ?? 'No autorizado')));
            return;
          }
          if (statusCode == 403) {
            handler.reject(DioException(requestOptions: e.requestOptions, error: ForbiddenException(message ?? 'Acceso denegado')));
            return;
          }
          if (statusCode != null && statusCode >= 500) {
            handler.reject(DioException(requestOptions: e.requestOptions, error: ServerException(message ?? 'Error interno del servidor')));
            return;
          }
          handler.next(e);
        },
      ),
    );
  }

  final Dio _dio;
  final TokenStorage _tokenStorage;
  final Future<String?> Function()? _onRefreshToken;

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return response.data;
  }

  Future<dynamic> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.post(path, data: data, queryParameters: queryParameters);
    return response.data;
  }

  Future<dynamic> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.put(path, data: data, queryParameters: queryParameters);
    return response.data;
  }

  Future<dynamic> patch(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.patch(path, data: data, queryParameters: queryParameters);
    return response.data;
  }

  Future<dynamic> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    final response = await _dio.delete(path, data: data, queryParameters: queryParameters);
    return response.data;
  }
}
