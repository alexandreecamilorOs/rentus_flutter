import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/providers/auth_provider.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/reset_password_screen.dart';
import '../../presentation/screens/auth/verify_email_screen.dart';
import '../../presentation/screens/home/about_screen.dart';
import '../../presentation/screens/home/contracts_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/home/maintenance_screen.dart';
import '../../presentation/screens/home/notifications_screen.dart';
import '../../presentation/screens/home/payments_screen.dart';
import '../../presentation/screens/home/profile_screen.dart';
import '../../presentation/screens/home/properties_screen.dart';
import '../../presentation/screens/home/property_create_screen.dart';
import '../../presentation/screens/home/property_detail_screen.dart';
import '../../presentation/screens/home/property_edit_screen.dart';
import '../../presentation/screens/home/reports_screen.dart';
import '../../presentation/screens/home/requests_screen.dart';
import '../../presentation/screens/home/settings_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const verifyEmail = '/verify-email';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const properties = '/properties';
  static const propertyDetail = '/properties/:id';
  static const propertyCreate = '/properties/create';
  static const propertyEdit = '/properties/:id/edit';
  static const profile = '/profile';
  static const settings = '/settings';
  static const payments = '/payments';
  static const contracts = '/contracts';
  static const maintenance = '/maintenance';
  static const reports = '/reports';
  static const notifications = '/notifications';
  static const requests = '/requests';
  static const about = '/about';
}

class RouterRefreshListenable extends ChangeNotifier {
  RouterRefreshListenable(Ref ref) {
    _subscription = ref.listen(authProvider, (_, __) => notifyListeners());
  }

  late final ProviderSubscription<AuthState> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}

final routerRefreshListenableProvider =
    Provider((ref) => RouterRefreshListenable(ref));

final routerProvider = Provider<GoRouter>((ref) {
  final listenable = ref.watch(routerRefreshListenableProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: listenable,
    redirect: (_, state) {
      final auth = ref.read(authProvider);
      final location = state.matchedLocation;

      final isAuthRoute = {
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.verifyEmail,
        AppRoutes.forgotPassword,
        AppRoutes.resetPassword,
      }.contains(location);

      if (!auth.isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }

      if (auth.isAuthenticated &&
          (location == AppRoutes.login || location == AppRoutes.register)) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(
          path: AppRoutes.register, builder: (_, __) => const RegisterScreen()),
      GoRoute(
          path: AppRoutes.verifyEmail,
          builder: (_, __) => const VerifyEmailScreen()),
      GoRoute(
          path: AppRoutes.forgotPassword,
          builder: (_, __) => const ForgotPasswordScreen()),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (_, state) =>
            ResetPasswordScreen(email: state.extra as String?),
      ),
      GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
      GoRoute(
          path: AppRoutes.properties,
          builder: (_, __) => const PropertiesScreen()),
      GoRoute(
          path: AppRoutes.propertyCreate,
          builder: (_, __) => const PropertyCreateScreen()),
      GoRoute(
        path: AppRoutes.propertyDetail,
        builder: (_, state) => PropertyDetailScreen(
            propertyId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
        path: AppRoutes.propertyEdit,
        builder: (_, state) => PropertyEditScreen(
            propertyId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
      ),
      GoRoute(
          path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
      GoRoute(
          path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()),
      GoRoute(
          path: AppRoutes.payments, builder: (_, __) => const PaymentsScreen()),
      GoRoute(
          path: AppRoutes.contracts,
          builder: (_, __) => const ContractsScreen()),
      GoRoute(
          path: AppRoutes.maintenance,
          builder: (_, __) => const MaintenanceScreen()),
      GoRoute(
          path: AppRoutes.reports, builder: (_, __) => const ReportsScreen()),
      GoRoute(
          path: AppRoutes.notifications,
          builder: (_, __) => const NotificationsScreen()),
      GoRoute(
          path: AppRoutes.requests, builder: (_, __) => const RequestsScreen()),
      GoRoute(path: AppRoutes.about, builder: (_, __) => const AboutScreen()),
    ],
  );
});
