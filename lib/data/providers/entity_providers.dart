import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_provider.dart';

import '../models/contract_model.dart';
import '../models/notification_model.dart';
import '../models/payment_model.dart';
import '../models/maintenance_model.dart';
import '../models/report_model.dart';
import '../models/paginated_response.dart';
import '../models/property_model.dart';
import '../models/rental_request_model.dart';
import 'repositories_providers.dart';

class PropertyListState {
  final List<Property> items;
  final int page;
  final bool hasMore;

  const PropertyListState(
      {required this.items, required this.page, required this.hasMore});

  PropertyListState copyWith(
          {List<Property>? items, int? page, bool? hasMore}) =>
      PropertyListState(
          items: items ?? this.items,
          page: page ?? this.page,
          hasMore: hasMore ?? this.hasMore);
}

class PropertyListNotifier extends AsyncNotifier<PropertyListState> {
  @override
  Future<PropertyListState> build() async => _fetch(1, const []);

  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || !current.hasMore) return;
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => _fetch(current.page + 1, current.items));
  }

  Future<PropertyListState> _fetch(int page, List<Property> previous) async {
    final PaginatedResponse<Property> response = await ref
        .read(propertyRepositoryProvider)
        .getProperties(queryParams: {'page': page});
    return PropertyListState(
      items: [...previous, ...response.data],
      page: response.meta.currentPage,
      hasMore: response.meta.currentPage < response.meta.lastPage,
    );
  }
}

final propertyListProvider =
    AsyncNotifierProvider<PropertyListNotifier, PropertyListState>(
        PropertyListNotifier.new);

final propertyDetailProvider =
    FutureProvider.family<Property, int>((ref, id) async {
  return ref.read(propertyRepositoryProvider).getPropertyById(id);
});

final myRequestsProvider = FutureProvider<List<RentalRequest>>((ref) async {
  return ref.read(rentalRequestRepositoryProvider).getMyRequests();
});

final myContractsProvider = FutureProvider<List<Contract>>((ref) async {
  return ref.read(contractRepositoryProvider).getContracts();
});

final notificationListProvider =
    FutureProvider<List<NotificationModel>>((ref) async {
  return ref.read(notificationRepositoryProvider).getNotifications();
});

// notificationListProvider remains above

final paymentsProvider = FutureProvider<List<Payment>>((ref) async {
  return ref.read(paymentRepositoryProvider).getPayments();
});

final maintenancesProvider = FutureProvider<List<Maintenance>>((ref) async {
  return ref.read(maintenanceRepositoryProvider).getMaintenances();
});

final reportsProvider = FutureProvider<List<Report>>((ref) async {
  return ref.read(reportRepositoryProvider).getReports();
});

final myPropertiesProvider = FutureProvider<List<Property>>((ref) async {
  final authState = ref.watch(authProvider);
  if (authState.user == null) return [];

  // Explicitly fetch properties for the logged in user
  final response = await ref.read(propertyRepositoryProvider).getProperties(
    queryParams: {'user_id': authState.user!.id},
  );
  return response.data;
});
