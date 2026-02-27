class RentalRequest {
  final int id;
  final int propertyId;
  final int tenantId;
  final String status;
  final String? message;

  RentalRequest({required this.id, required this.propertyId, required this.tenantId, required this.status, this.message});

  factory RentalRequest.fromJson(Map<String, dynamic> json) => RentalRequest(
        id: json['id'] ?? 0,
        propertyId: json['property_id'] ?? 0,
        tenantId: json['tenant_id'] ?? 0,
        status: json['status'] ?? 'pending',
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {'id': id, 'property_id': propertyId, 'tenant_id': tenantId, 'status': status, 'message': message};
}
