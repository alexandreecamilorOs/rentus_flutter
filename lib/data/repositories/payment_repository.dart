import '../models/payment_model.dart';
import '../services/api_client.dart';
import 'repository_utils.dart';

class PaymentRepository {
  PaymentRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<List<Payment>> getPayments() async => extractList(await _apiClient.get('/payments')).map(Payment.fromJson).toList();
  Future<Payment> createPayment(Map<String, dynamic> data) async => Payment.fromJson(extractMap(await _apiClient.post('/payments', data: data)));
  Future<Map<String, dynamic>> simulatePayment(Map<String, dynamic> data) async => extractMap(await _apiClient.post('/payments/simulate', data: data));
  Future<Payment> updatePaymentStatus(int id, String status) async => Payment.fromJson(extractMap(await _apiClient.patch('/payments/$id/status', data: {'status': status})));
}
