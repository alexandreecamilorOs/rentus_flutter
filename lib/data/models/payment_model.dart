class Payment {
  final int id;
  final int? contractId;
  final double amount;
  final String status;

  Payment({required this.id, this.contractId, required this.amount, required this.status});

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'] ?? 0,
        contractId: json['contract_id'],
        amount: (json['amount'] as num?)?.toDouble() ?? 0,
        status: json['status'] ?? 'pending',
      );

  Map<String, dynamic> toJson() => {'id': id, 'contract_id': contractId, 'amount': amount, 'status': status};
}

class PaymentMethod {
  final int id;
  final String type;
  final String last4;
  final bool isDefault;

  PaymentMethod({required this.id, required this.type, required this.last4, required this.isDefault});

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'] ?? 0,
        type: json['type'] ?? 'card',
        last4: json['last4']?.toString() ?? '',
        isDefault: json['is_default'] ?? false,
      );

  Map<String, dynamic> toJson() => {'id': id, 'type': type, 'last4': last4, 'is_default': isDefault};
}
