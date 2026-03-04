import 'contract_model.dart';

class Payment {
  final int id;
  final int? contractId;
  final double amount;
  final String status;
  final String? createdAt;
  final String? type;
  final String? cardLastFour;
  final Contract? contract;

  Payment({
    required this.id,
    this.contractId,
    required this.amount,
    required this.status,
    this.createdAt,
    this.type,
    this.cardLastFour,
    this.contract,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    return Payment(
      id: json['id'] ?? 0,
      contractId: json['contract_id'],
      amount: _toDouble(json['amount']),
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'],
      type: json['type'],
      cardLastFour: json['card_last_four'],
      contract:
          json['contract'] != null ? Contract.fromJson(json['contract']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'contract_id': contractId,
        'amount': amount,
        'status': status,
        'created_at': createdAt,
        'type': type,
        'card_last_four': cardLastFour,
        'contract': contract?.toJson(),
      };
}

class PaymentMethod {
  final int id;
  final String type;
  final String? lastFour;
  final String? holderName;
  final String? expiryDate;
  final bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    this.lastFour,
    this.holderName,
    this.expiryDate,
    required this.isDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'] ?? 0,
        type: json['type'] ?? 'card',
        lastFour: (json['last_four'] ?? json['last4'])?.toString(),
        holderName: json['holder_name'],
        expiryDate: json['expiry_date'],
        isDefault: json['is_default'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'last_four': lastFour,
        'holder_name': holderName,
        'expiry_date': expiryDate,
        'is_default': isDefault,
      };
}
