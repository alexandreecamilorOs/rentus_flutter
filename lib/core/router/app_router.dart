import 'package:go_router/go_router.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
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

final router = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
    GoRoute(path: AppRoutes.register, builder: (_, __) => const RegisterScreen()),
    GoRoute(path: AppRoutes.home, builder: (_, __) => const HomeScreen()),
    GoRoute(path: AppRoutes.properties, builder: (_, __) => const PropertiesScreen()),
    GoRoute(
      path: AppRoutes.propertyDetail,
      builder: (_, state) => PropertyDetailScreen(propertyId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
    ),
    GoRoute(path: AppRoutes.propertyCreate, builder: (_, __) => const PropertyCreateScreen()),
    GoRoute(
      path: AppRoutes.propertyEdit,
      builder: (_, state) => PropertyEditScreen(propertyId: int.tryParse(state.pathParameters['id'] ?? '') ?? 0),
    ),
    GoRoute(path: AppRoutes.profile, builder: (_, __) => const ProfileScreen()),
    GoRoute(path: AppRoutes.settings, builder: (_, __) => const SettingsScreen()),
    GoRoute(path: AppRoutes.payments, builder: (_, __) => const PaymentsScreen()),
    GoRoute(path: AppRoutes.contracts, builder: (_, __) => const ContractsScreen()),
    GoRoute(path: AppRoutes.maintenance, builder: (_, __) => const MaintenanceScreen()),
    GoRoute(path: AppRoutes.reports, builder: (_, __) => const ReportsScreen()),
    GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),
    GoRoute(path: AppRoutes.requests, builder: (_, __) => const RequestsScreen()),
    GoRoute(path: AppRoutes.about, builder: (_, __) => const AboutScreen()),
  ],
);
