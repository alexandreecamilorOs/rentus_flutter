import '../services/api_client.dart';
import 'repository_utils.dart';

class GeocodingRepository {
  GeocodingRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<Map<String, dynamic>>> searchAddress(String query) async {
    final res = await _apiClient.get('/geocoding/search', queryParameters: {'query': query});
    return extractList(res);
  }
}
