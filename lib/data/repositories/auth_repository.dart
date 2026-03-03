import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../models/user_model.dart';
import '../services/token_storage.dart';

class AuthRepository {
  AuthRepository(this._tokenStorage, {Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              headers: {
                'Accept': 'application/json',
                'Content-Type': 'application/json',
              },
            )) {
    _dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  final Dio _dio;
  final TokenStorage _tokenStorage;

  Future<User> login(
      {required String email,
      required String password,
      bool remember = false}) async {
    final response = await _dio.post('/auth/login',
        data: {'email': email, 'password': password, 'remember': remember});
    final body = response.data;
    if (body is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        error:
            'El servidor no devolvió una respuesta JSON válida (se recibió HTML).',
      );
    }
    return _persistAuthResponse(body);
  }

  Future<String?> register(RegisterData data) async {
    final response = await _dio.post('/auth/register', data: data.toJson());
    final body = response.data;
    if (body is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        error:
            'El servidor no devolvió una respuesta JSON válida (se recibió HTML).',
      );
    }
    return body['verification_token']?.toString() ??
        body['data']?['verification_token']?.toString();
  }

  Future<void> resendCode(String email) async {
    await _dio.post('/auth/resend-code', data: {'email': email});
  }

  Future<User> verifyEmail(
      {required String email, required String code, String? token}) async {
    final response = await _dio.post('/auth/verify-email',
        data: {'email': email, 'code': code, 'token': token});
    final body = response.data;
    if (body is! Map) {
      throw DioException(
        requestOptions: response.requestOptions,
        error:
            'El servidor no devolvió una respuesta JSON válida (se recibió HTML).',
      );
    }
    // According to Vue service, user might be in body['data']['user'] or body['user']
    return _persistAuthResponse(body);
  }

  Future<void> forgotPassword(String email) async {
    await _dio.post('/auth/forgot-password', data: {'email': email});
  }

  Future<void> resetPassword(
      {required String email,
      required String code,
      required String password,
      required String passwordConfirmation}) async {
    await _dio.post('/auth/reset-password', data: {
      'email': email,
      'code': code,
      'password': password,
      'password_confirmation': passwordConfirmation
    });
  }

  Future<User> getMe(String accessToken) async {
    final response = await _dio.get('/auth/me',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
    final map =
        (response.data['data'] ?? response.data) as Map<String, dynamic>;
    return User.fromJson(map);
  }

  Future<String?> refreshToken() async {
    final accessToken = await _tokenStorage.readAccessToken();
    final refreshToken = await _tokenStorage.readRefreshToken();

    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
      options: Options(
          headers: accessToken == null
              ? null
              : {'Authorization': 'Bearer $accessToken'}),
    );

    final token = response.data['access_token']?.toString() ??
        response.data['token']?.toString();
    final newRefresh = response.data['refresh_token']?.toString();
    if (token != null && token.isNotEmpty) {
      await _tokenStorage.saveTokens(
          accessToken: token, refreshToken: newRefresh ?? refreshToken);
    }
    return token;
  }

  Future<void> logout() async {
    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken != null) {
      await _dio.post('/auth/logout',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}));
    }
    await _tokenStorage.clear();
  }

  Future<User?> tryRestoreSession() async {
    final token = await _tokenStorage.readAccessToken();
    if (token == null || token.isEmpty) return null;
    return getMe(token);
  }

  Future<bool> checkToken(String token) async {
    try {
      await getMe(token);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    final accessToken = await _tokenStorage.readAccessToken();
    await _dio.post(
      '/auth/update-password',
      data: {'current_password': currentPassword, 'new_password': newPassword},
      options: Options(
          headers: accessToken == null
              ? null
              : {'Authorization': 'Bearer $accessToken'}),
    );
  }

  Future<User> _persistAuthResponse(dynamic body) async {
    final token =
        body['access_token']?.toString() ?? body['token']?.toString() ?? '';
    final refresh = body['refresh_token']?.toString();
    if (token.isNotEmpty) {
      await _tokenStorage.saveTokens(accessToken: token, refreshToken: refresh);
    }
    final userMap = (body['user'] ?? body['data']?['user'] ?? body['data'])
            as Map<String, dynamic>? ??
        <String, dynamic>{};
    return User.fromJson(userMap);
  }
}
