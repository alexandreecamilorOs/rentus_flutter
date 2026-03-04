import '../models/report_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class ReportRepository {
  ReportRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<Report>> getReports() async => extractList(await _apiClient.get('/reports')).map(Report.fromJson).toList();
  Future<Report> createReport(Map<String, dynamic> data) async => Report.fromJson(extractMap(await _apiClient.post('/reports', data: data)));
  Future<Report> updateReport(int id, Map<String, dynamic> data) async => Report.fromJson(extractMap(await _apiClient.put('/reports/$id', data: data)));
  Future<void> deleteReport(int id) => _apiClient.delete('/reports/$id');
}
