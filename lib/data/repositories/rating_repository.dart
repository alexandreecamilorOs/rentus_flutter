import '../models/rating_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class RatingRepository {
  RatingRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<Rating>> getRatings() async => extractList(await _apiClient.get('/ratings')).map(Rating.fromJson).toList();
  Future<Rating> createRating(Map<String, dynamic> data) async => Rating.fromJson(extractMap(await _apiClient.post('/ratings', data: data)));
  Future<Rating> updateRating(int id, Map<String, dynamic> data) async => Rating.fromJson(extractMap(await _apiClient.put('/ratings/$id', data: data)));
  Future<void> deleteRating(int id) => _apiClient.delete('/ratings/$id');
}
