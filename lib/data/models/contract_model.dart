class Contract {
  final int id;
  final int propertyId;
  final int ownerId;
  final int tenantId;
  final String status;

  Contract({required this.id, required this.propertyId, required this.ownerId, required this.tenantId, required this.status});

  factory Contract.fromJson(Map<String, dynamic> json) => Contract(
        id: json['id'] ?? 0,
        propertyId: json['property_id'] ?? 0,
        ownerId: json['owner_id'] ?? 0,
        tenantId: json['tenant_id'] ?? 0,
        status: json['status'] ?? 'pending',
      );

  Map<String, dynamic> toJson() => {'id': id, 'property_id': propertyId, 'owner_id': ownerId, 'tenant_id': tenantId, 'status': status};
}
