import '../models/notification_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class NotificationRepository {
  NotificationRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<NotificationModel>> getNotifications({bool unreadOnly = false}) async {
    final res = await _apiClient.get('/notifications', queryParameters: {'unread_only': unreadOnly});
    return extractList(res).map(NotificationModel.fromJson).toList();
  }

  Future<void> markAsRead(int id) => _apiClient.post('/notifications/$id/read');
  Future<void> markAllAsRead() => _apiClient.post('/notifications/read-all');
  Future<void> deleteNotification(int id) => _apiClient.delete('/notifications/$id');
}
