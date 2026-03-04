class RentalRequest {
  final int id;
  final int propertyId;
  final int tenantId;
  final int? ownerId;
  final String status;
  final String? message;
  final String? requestedDate;
  final String? requestedTime;
  final String? counterDate;
  final String? counterTime;
  final Map<String, dynamic>? property;
  final Map<String, dynamic>? user;
  final String? visitEndTime;

  RentalRequest({
    required this.id,
    required this.propertyId,
    required this.tenantId,
    this.ownerId,
    required this.status,
    this.message,
    this.requestedDate,
    this.requestedTime,
    this.counterDate,
    this.counterTime,
    this.property,
    this.user,
    this.visitEndTime,
  });

  factory RentalRequest.fromJson(Map<String, dynamic> json) => RentalRequest(
        id: json['id'] is int
            ? json['id']
            : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        propertyId: json['property_id'] is int
            ? json['property_id']
            : int.tryParse(json['property_id']?.toString() ?? '0') ?? 0,
        tenantId: json['tenant_id'] is int
            ? json['tenant_id']
            : int.tryParse(json['tenant_id']?.toString() ?? '0') ?? 0,
        ownerId: json['owner_id'] is int
            ? json['owner_id']
            : int.tryParse(json['owner_id']?.toString() ?? ''),
        status: json['status'] ?? 'pending',
        message: json['message']?.toString(),
        requestedDate: json['requested_date']?.toString(),
        requestedTime: json['requested_time']?.toString(),
        counterDate: json['counter_date']?.toString(),
        counterTime: json['counter_time']?.toString(),
        visitEndTime: json['visit_end_time']?.toString(),
        property: json['property'] as Map<String, dynamic>?,
        user: json['user'] as Map<String, dynamic>? ??
            json['tenant'] as Map<String, dynamic>?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'tenant_id': tenantId,
        'owner_id': ownerId,
        'status': status,
        'message': message,
        'requested_date': requestedDate,
        'requested_time': requestedTime,
        'counter_date': counterDate,
        'counter_time': counterTime,
        'visit_end_time': visitEndTime,
        'property': property,
        'user': user,
      };
}
