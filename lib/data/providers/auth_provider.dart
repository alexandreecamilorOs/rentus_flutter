import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/token_storage.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState(
      {required this.status,
      this.user,
      this.message,
      this.pendingVerificationToken,
      this.pendingVerificationEmail});

  final AuthStatus status;
  final User? user;
  final String? message;
  final String? pendingVerificationToken;
  final String? pendingVerificationEmail;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? message,
    String? pendingVerificationToken,
    String? pendingVerificationEmail,
    bool clearPending = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
      pendingVerificationToken: clearPending
          ? null
          : (pendingVerificationToken ?? this.pendingVerificationToken),
      pendingVerificationEmail: clearPending
          ? null
          : (pendingVerificationEmail ?? this.pendingVerificationEmail),
    );
  }

  static const initial = AuthState(status: AuthStatus.initial);
}

String _friendlyError(Object e) {
  if (e is DioException) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return 'No se pudo conectar con el servidor. Verifica tu conexión a internet.';
    }

    final response = e.response;
    if (response != null) {
      final statusCode = response.statusCode;
      final data = response.data;

      // Map common status codes to friendly messages
      switch (statusCode) {
        case 400:
          return 'Solicitud inválida. Revisa los datos ingresados.';
        case 401:
          return 'Credenciales incorrectas. Verifica tu correo o contraseña.';
        case 403:
          if (data is Map && data['data']?['verification_required'] == true) {
            return 'Email no verificado.';
          }
          return 'No tienes permiso para realizar esta acción.';
        case 404:
          return 'El recurso solicitado no fue encontrado.';
        case 422:
          // Often used for validation errors (e.g., email already taken)
          if (data is Map && data['message'] != null) {
            final msg = data['message'].toString();
            if (msg.contains('already taken') || msg.contains('existe')) {
              return 'Este correo ya está registrado.';
            }
            return msg;
          }
          return 'Error de validación. Revisa los campos.';
        case 500:
          return 'Error interno del servidor. Inténtalo más tarde.';
      }
    }
  }

  final msg = e.toString();
  if (msg.contains('XMLHttpRequest') || msg.contains('connection error')) {
    return 'Error de conexión. Verifica el servidor.';
  }

  return 'Ocurrió un error inesperado. Inténtalo de nuevo.';
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._repository) : super(AuthState.initial) {
    bootstrap();
  }

  final AuthRepository _repository;

  Future<void> bootstrap() async {
    try {
      final user = await _repository.tryRestoreSession();
      if (user != null) {
        state = state.copyWith(
            status: AuthStatus.authenticated, user: user, clearPending: true);
      } else {
        state = state.copyWith(
            status: AuthStatus.unauthenticated, clearPending: true);
      }
    } catch (_) {
      state = state.copyWith(
          status: AuthStatus.unauthenticated, clearPending: true);
    }
  }

  Future<bool> login(String email, String password,
      {bool remember = false}) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      print('AUTH: Attempting login for $email');
      final user = await _repository.login(
          email: email, password: password, remember: remember);
      print('AUTH: Login successful for ${user.email}');
      state = state.copyWith(
          status: AuthStatus.authenticated, user: user, clearPending: true);
      return true;
    } catch (e) {
      print('AUTH ERROR (login): $e');
      String errorMsg = _friendlyError(e);

      if (e is DioException && e.response?.statusCode == 403) {
        final data = e.response?.data;
        if (data is Map && data['data']?['verification_required'] == true) {
          final email = data['data']?['email'] as String?;
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            message: 'Email no verificado.',
            pendingVerificationEmail: email,
          );
          return false;
        }
      }

      state = state.copyWith(status: AuthStatus.error, message: errorMsg);
      return false;
    }
  }

  Future<bool> register(RegisterData data) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      print('AUTH: Attempting register for ${data.email}');
      final token = await _repository.register(data);
      print(
          'AUTH: Registration successful, pending verification. Token: $token');
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        pendingVerificationToken: token,
        pendingVerificationEmail: data.email,
      );
      return true;
    } catch (e) {
      print('AUTH ERROR (register): $e');
      state =
          state.copyWith(status: AuthStatus.error, message: _friendlyError(e));
      return false;
    }
  }

  Future<bool> verifyEmail(String email, String code, [String? token]) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      print('AUTH: Verifying email $email with code $code');
      final user = await _repository.verifyEmail(
        email: email,
        code: code,
        token: token,
      );
      print('AUTH: Verification successful for ${user.email}');
      state = state.copyWith(status: AuthStatus.authenticated, user: user);
      return true;
    } catch (e) {
      print('AUTH ERROR (verifyEmail): $e');
      state =
          state.copyWith(status: AuthStatus.error, message: _friendlyError(e));
      return false;
    }
  }

  Future<bool> resendCode(String email) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      print('AUTH: Resending code to $email');
      await _repository.resendCode(email);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      print('AUTH ERROR (resendCode): $e');
      state =
          state.copyWith(status: AuthStatus.error, message: _friendlyError(e));
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      print('AUTH: Requesting password reset for $email');
      await _repository.forgotPassword(email);
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      print('AUTH ERROR (forgotPassword): $e');
      state =
          state.copyWith(status: AuthStatus.error, message: _friendlyError(e));
      return false;
    }
  }

  Future<bool> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      print('AUTH: Resetting password for $email');
      await _repository.resetPassword(
        email: email,
        code: code,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return true;
    } catch (e) {
      print('AUTH ERROR (resetPassword): $e');
      state =
          state.copyWith(status: AuthStatus.error, message: _friendlyError(e));
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = state.copyWith(
        status: AuthStatus.unauthenticated, user: null, clearPending: true);
  }

  Future<void> refreshUserProfile() async {
    try {
      final user = await _repository.tryRestoreSession();
      if (user != null) {
        state = state.copyWith(user: user);
      }
    } catch (e) {
      print('AUTH ERROR (refreshUserProfile): $e');
    }
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());
final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => AuthRepository(ref.read(tokenStorageProvider)));
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
    (ref) => AuthNotifier(ref.read(authRepositoryProvider)));
