import '../services/api_client.dart';
import 'repository_utils.dart';

class AdminRepository {
  AdminRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<Map<String, dynamic>> getDashboardStats() async => extractMap(await _apiClient.get('/admin/dashboard-stats'));
  Future<List<Map<String, dynamic>>> getPendingProperties() async => extractList(await _apiClient.get('/admin/properties/pending'));
  Future<void> approveProperty(int id) => _apiClient.post('/admin/properties/$id/approve');
}
