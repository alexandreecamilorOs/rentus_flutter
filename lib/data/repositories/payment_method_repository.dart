import '../models/payment_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class PaymentMethodRepository {
  PaymentMethodRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<PaymentMethod>> getMethods() async => extractList(await _apiClient.get('/payment-methods')).map(PaymentMethod.fromJson).toList();
  Future<PaymentMethod> createMethod(Map<String, dynamic> data) async => PaymentMethod.fromJson(extractMap(await _apiClient.post('/payment-methods', data: data)));
  Future<void> deleteMethod(int id) => _apiClient.delete('/payment-methods/$id');
}
