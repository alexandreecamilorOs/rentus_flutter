import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';

import '../../presentation/screens/home/properties_screen.dart';
import '../../presentation/screens/home/property_detail_screen.dart';
import '../../presentation/screens/home/property_create_screen.dart';
import '../../presentation/screens/home/property_edit_screen.dart';
import '../../presentation/screens/home/profile_screen.dart';
import '../../presentation/screens/home/settings_screen.dart';
import '../../presentation/screens/home/payments_screen.dart';
import '../../presentation/screens/home/contracts_screen.dart';
import '../../presentation/screens/home/maintenance_screen.dart';
import '../../presentation/screens/home/reports_screen.dart';
import '../../presentation/screens/home/notifications_screen.dart';
import '../../presentation/screens/home/requests_screen.dart';
import '../../presentation/screens/home/about_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String properties = '/properties';
  static const String propertyDetail = '/properties/detail';
  static const String propertyCreate = '/properties/create';
  static const String propertyEdit = '/properties/edit';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String payments = '/payments';
  static const String contracts = '/contracts';
  static const String maintenance = '/maintenance';
  static const String reports = '/reports';
  static const String notifications = '/notifications';
  static const String requests = '/requests';
  static const String about = '/about';
}

final router = GoRouter(
  initialLocation: AppRoutes.login, // Inicia temporalmente en login
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.properties,
      builder: (context, state) => const PropertiesScreen(),
    ),
    GoRoute(
      path: AppRoutes.propertyDetail,
      builder: (context, state) => const PropertyDetailScreen(),
    ),
    GoRoute(
      path: AppRoutes.propertyCreate,
      builder: (context, state) => const PropertyCreateScreen(),
    ),
    GoRoute(
      path: AppRoutes.propertyEdit,
      builder: (context, state) => const PropertyEditScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: AppRoutes.payments,
      builder: (context, state) => const PaymentsScreen(),
    ),
    GoRoute(
      path: AppRoutes.contracts,
      builder: (context, state) => const ContractsScreen(),
    ),
    GoRoute(
      path: AppRoutes.maintenance,
      builder: (context, state) => const MaintenanceScreen(),
    ),
    GoRoute(
      path: AppRoutes.reports,
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: AppRoutes.notifications,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: AppRoutes.requests,
      builder: (context, state) => const RequestsScreen(),
    ),
    GoRoute(
      path: AppRoutes.about,
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
