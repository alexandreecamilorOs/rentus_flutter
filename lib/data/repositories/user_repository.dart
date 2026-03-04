import '../models/user_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class UserRepository {
  UserRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<User>> getUsers() async => extractList(await _apiClient.get('/users')).map(User.fromJson).toList();
  Future<Map<String, dynamic>> getUserStats() async => extractMap(await _apiClient.get('/users/stats'));
  Future<User> getUserById(int id) async => User.fromJson(extractMap(await _apiClient.get('/users/$id')));
  Future<User> updateUser(int id, Map<String, dynamic> data) async => User.fromJson(extractMap(await _apiClient.put('/users/$id', data: data)));
  Future<User> updateUserStatus(int id, String status) async => User.fromJson(extractMap(await _apiClient.patch('/users/$id/status', data: {'status': status})));

  Future<User> getProfile() async => User.fromJson(extractMap(await _apiClient.get('/auth/me')));
}
