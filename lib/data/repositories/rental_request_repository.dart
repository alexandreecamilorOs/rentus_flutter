import '../models/rental_request_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class RentalRequestRepository {
  RentalRequestRepository(this._apiClient);
  final ApiClient _apiClient;

  // Tenant: requests I made
  Future<List<RentalRequest>> getMyRequests() async =>
      _parse(await _apiClient.get('/rental-requests/my-requests'));

  // Owner: requests received on my properties
  Future<List<RentalRequest>> getMyReceivedRequests() async =>
      _parse(await _apiClient.get('/rental-requests/my-received'));

  Future<RentalRequest> createRequest(Map<String, dynamic> data) async =>
      RentalRequest.fromJson(
          (await _apiClient.post('/rental-requests', data: data))['data']);

  // Owner actions — Vue uses PUT
  Future<void> acceptRequest(int id) =>
      _apiClient.put('/rental-requests/$id/accept');
  Future<void> rejectRequest(int id) =>
      _apiClient.put('/rental-requests/$id/reject');
  Future<void> counterOffer(int id, Map<String, dynamic> data) =>
      _apiClient.put('/rental-requests/$id/counter-propose', data: data);

  // Tenant actions — Vue uses PUT
  Future<void> acceptCounter(int id) =>
      _apiClient.put('/rental-requests/$id/accept-counter');
  Future<void> rejectCounter(int id) =>
      _apiClient.put('/rental-requests/$id/reject-counter');

  // Cancel (tenant) — Vue uses DELETE
  Future<void> cancelRequest(int id) =>
      _apiClient.delete('/rental-requests/$id');

  Future<String> getVisitStatus(int id) async =>
      (await _apiClient.get('/rental-requests/$id/visit-status'))['status'] ??
      '';

  // Send contract — Vue uses POST to /rental-requests/send-contract
  Future<void> sendContract(int id, Map<String, dynamic> terms) =>
      _apiClient.post('/rental-requests/send-contract',
          data: {...terms, 'rental_request_id': id});

  List<RentalRequest> _parse(dynamic data) =>
      extractList(data).map(RentalRequest.fromJson).toList();
}
