import '../models/rental_request_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class RentalRequestRepository {
  RentalRequestRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<RentalRequest>> getMyRequests() async => _parse(await _apiClient.get('/rental-requests/my'));
  Future<List<RentalRequest>> getMyReceivedRequests() async => _parse(await _apiClient.get('/rental-requests/received'));
  Future<RentalRequest> createRequest(Map<String, dynamic> data) async => RentalRequest.fromJson((await _apiClient.post('/rental-requests', data: data))['data']);
  Future<void> acceptRequest(int id) => _apiClient.post('/rental-requests/$id/accept');
  Future<void> rejectRequest(int id) => _apiClient.post('/rental-requests/$id/reject');
  Future<void> counterOffer(int id, Map<String, dynamic> data) => _apiClient.post('/rental-requests/$id/counter-offer', data: data);
  Future<void> acceptCounter(int id) => _apiClient.post('/rental-requests/$id/accept-counter');
  Future<void> rejectCounter(int id) => _apiClient.post('/rental-requests/$id/reject-counter');
  Future<String> getVisitStatus(int id) async => (await _apiClient.get('/rental-requests/$id/visit-status'))['status'] ?? '';
  Future<void> sendContract(int id) => _apiClient.post('/rental-requests/$id/send-contract');

  List<RentalRequest> _parse(dynamic data) => extractList(data).map(RentalRequest.fromJson).toList();
}
