import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/admin_repository.dart';
import '../repositories/auth_repository.dart';
import '../repositories/contract_repository.dart';
import '../repositories/geocoding_repository.dart';
import '../repositories/maintenance_repository.dart';
import '../repositories/notification_repository.dart';
import '../repositories/payment_method_repository.dart';
import '../repositories/payment_repository.dart';
import '../repositories/property_repository.dart';
import '../repositories/rating_repository.dart';
import '../repositories/rental_request_repository.dart';
import '../repositories/report_repository.dart';
import '../repositories/user_repository.dart';
import '../services/api_client.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());
final propertyRepositoryProvider = Provider<PropertyRepository>((ref) => PropertyRepository(ref.read(apiClientProvider)));
final rentalRequestRepositoryProvider = Provider<RentalRequestRepository>((ref) => RentalRequestRepository(ref.read(apiClientProvider)));
final contractRepositoryProvider = Provider<ContractRepository>((ref) => ContractRepository(ref.read(apiClientProvider)));
final paymentRepositoryProvider = Provider<PaymentRepository>((ref) => PaymentRepository(ref.read(apiClientProvider)));
final paymentMethodRepositoryProvider = Provider<PaymentMethodRepository>((ref) => PaymentMethodRepository(ref.read(apiClientProvider)));
final ratingRepositoryProvider = Provider<RatingRepository>((ref) => RatingRepository(ref.read(apiClientProvider)));
final reportRepositoryProvider = Provider<ReportRepository>((ref) => ReportRepository(ref.read(apiClientProvider)));
final maintenanceRepositoryProvider = Provider<MaintenanceRepository>((ref) => MaintenanceRepository(ref.read(apiClientProvider)));
final notificationRepositoryProvider = Provider<NotificationRepository>((ref) => NotificationRepository(ref.read(apiClientProvider)));
final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository(ref.read(apiClientProvider)));
final adminRepositoryProvider = Provider<AdminRepository>((ref) => AdminRepository(ref.read(apiClientProvider)));
final geocodingRepositoryProvider = Provider<GeocodingRepository>((ref) => GeocodingRepository(ref.read(apiClientProvider)));
