import 'property_model.dart';
import 'user_model.dart';

class Contract {
  final int id;
  final int propertyId;
  final int? landlordId;
  final int? tenantId;
  final String status;
  final Property? property;
  final User? tenant;
  final User? landlord;
  final String? startDate;
  final String? endDate;
  final double? monthlyPrice;
  final double? deposit;
  final List<String> clauses;

  Contract({
    required this.id,
    required this.propertyId,
    this.landlordId,
    this.tenantId,
    required this.status,
    this.property,
    this.tenant,
    this.landlord,
    this.startDate,
    this.endDate,
    this.monthlyPrice,
    this.deposit,
    this.clauses = const [],
  });

  // Safely parse a value that may be a num or a String like "1644401.00"
  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'] ?? 0,
      propertyId: json['property_id'] ?? 0,
      landlordId: json['landlord_id'],
      tenantId: json['tenant_id'],
      status: json['status'] ?? 'pending',
      property:
          json['property'] != null ? Property.fromJson(json['property']) : null,
      tenant: json['tenant'] != null ? User.fromJson(json['tenant']) : null,
      landlord:
          json['landlord'] != null ? User.fromJson(json['landlord']) : null,
      startDate: json['start_date'],
      endDate: json['end_date'],
      // Backend can return numeric fields as strings like "1644401.00"
      monthlyPrice: _toDouble(json['monthly_rent']) ??
          _toDouble(json['monthly_price']) ??
          _toDouble(json['property']?['monthly_rent']) ??
          _toDouble(json['property']?['monthly_price']),
      deposit: _toDouble(json['deposit_amount']) ?? _toDouble(json['deposit']),
      clauses:
          (json['clauses'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'landlord_id': landlordId,
        'tenant_id': tenantId,
        'status': status,
        'property': property?.toJson(),
        'tenant': tenant?.toJson(),
        'landlord': landlord?.toJson(),
        'start_date': startDate,
        'end_date': endDate,
        'monthly_price': monthlyPrice,
        'deposit': deposit,
        'clauses': clauses,
      };
}
