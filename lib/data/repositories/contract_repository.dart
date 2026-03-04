import '../models/contract_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class ContractRepository {
  ContractRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<Contract>> getContracts() async => extractList(await _apiClient.get('/contracts')).map(Contract.fromJson).toList();
  Future<Map<String, dynamic>> getContractStats() async => extractMap(await _apiClient.get('/contracts/stats'));
  Future<Contract> getContractById(int id) async => Contract.fromJson(extractMap(await _apiClient.get('/contracts/$id')));
  Future<void> acceptContract(int id) => _apiClient.post('/contracts/$id/accept');
  Future<void> rejectContract(int id) => _apiClient.post('/contracts/$id/reject');
}
