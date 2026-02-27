import '../models/paginated_response.dart';
import '../models/property_model.dart';
import '../services/api_client.dart';

class PropertyRepository {
  PropertyRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<PaginatedResponse<Property>> getProperties({Map<String, dynamic>? queryParams}) async {
    final params = {'approval_status': 'approved', 'visibility': 'published', ...?queryParams};
    final data = await _apiClient.get('/properties', queryParameters: params);
    return PaginatedResponse.fromJson(data as Map<String, dynamic>, Property.fromJson);
  }

  Future<Property> getPropertyById(int id) async {
    final data = await _apiClient.get('/properties/$id');
    final map = (data['data'] ?? data) as Map<String, dynamic>;
    return Property.fromJson(map);
  }

  Future<Property> createProperty(Map<String, dynamic> body) async {
    final data = await _apiClient.post('/properties', data: body);
    return Property.fromJson((data['data'] ?? data) as Map<String, dynamic>);
  }

  Future<Property> updateProperty(int id, Map<String, dynamic> body) async {
    final data = await _apiClient.put('/properties/$id', data: body);
    return Property.fromJson((data['data'] ?? data) as Map<String, dynamic>);
  }

  Future<void> deleteProperty(int id) => _apiClient.delete('/properties/$id');
  Future<void> incrementViewCount(int id) => _apiClient.post('/properties/$id/increment-view');
  Future<void> saveGeoPoint(int id, double lat, double lng) => _apiClient.patch('/properties/$id/geopoint', data: {'latitude': lat, 'longitude': lng});
}
