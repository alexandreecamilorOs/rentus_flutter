import '../models/maintenance_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class MaintenanceRepository {
  MaintenanceRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<Maintenance>> getMaintenances() async => extractList(await _apiClient.get('/maintenances')).map(Maintenance.fromJson).toList();
  Future<Maintenance> createMaintenance(Map<String, dynamic> data) async => Maintenance.fromJson(extractMap(await _apiClient.post('/maintenances', data: data)));
  Future<Maintenance> updateMaintenance(int id, Map<String, dynamic> data) async => Maintenance.fromJson(extractMap(await _apiClient.put('/maintenances/$id', data: data)));
  Future<void> deleteMaintenance(int id) => _apiClient.delete('/maintenances/$id');
}
