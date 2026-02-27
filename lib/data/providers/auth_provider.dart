import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/token_storage.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({required this.status, this.user, this.message, this.pendingVerificationToken, this.pendingVerificationEmail});

  final AuthStatus status;
  final User? user;
  final String? message;
  final String? pendingVerificationToken;
  final String? pendingVerificationEmail;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

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
      pendingVerificationToken: clearPending ? null : (pendingVerificationToken ?? this.pendingVerificationToken),
      pendingVerificationEmail: clearPending ? null : (pendingVerificationEmail ?? this.pendingVerificationEmail),
    );
  }

  static const initial = AuthState(status: AuthStatus.initial);
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
        state = state.copyWith(status: AuthStatus.authenticated, user: user, clearPending: true);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated, clearPending: true);
      }
    } catch (_) {
      state = state.copyWith(status: AuthStatus.unauthenticated, clearPending: true);
    }
  }

  Future<bool> login(String email, String password, {bool remember = false}) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      final user = await _repository.login(email: email, password: password, remember: remember);
      state = state.copyWith(status: AuthStatus.authenticated, user: user, clearPending: true);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
      return false;
    }
  }

  Future<bool> register(RegisterData data) async {
    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      final token = await _repository.register(data);
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        pendingVerificationToken: token,
        pendingVerificationEmail: data.email,
      );
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
      return false;
    }
  }

  Future<bool> verifyEmail(String code) async {
    final token = state.pendingVerificationToken;
    if (token == null || token.isEmpty) {
      state = state.copyWith(status: AuthStatus.error, message: 'No hay token de verificación.');
      return false;
    }

    state = state.copyWith(status: AuthStatus.loading, message: null);
    try {
      final user = await _repository.verifyEmail(code: code, token: token);
      state = state.copyWith(status: AuthStatus.authenticated, user: user, clearPending: true);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, message: e.toString());
      return false;
    }
  }

  Future<void> resendCode() async {
    final email = state.pendingVerificationEmail;
    if (email == null || email.isEmpty) return;
    await _repository.resendCode(email);
  }

  Future<void> logout() async {
    await _repository.logout();
    state = state.copyWith(status: AuthStatus.unauthenticated, user: null, clearPending: true);
  }
}

final tokenStorageProvider = Provider<TokenStorage>((ref) => TokenStorage());
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(ref.read(tokenStorageProvider)));
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier(ref.read(authRepositoryProvider)));
