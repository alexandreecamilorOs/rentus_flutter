class Maintenance {
  final int id;
  final int propertyId;
  final int userId;
  final String description;
  final String status;

  Maintenance(
      {required this.id,
      required this.propertyId,
      required this.userId,
      required this.description,
      required this.status});

  factory Maintenance.fromJson(Map<String, dynamic> json) => Maintenance(
        id: json['id'] ?? 0,
        propertyId: json['property_id'] ?? 0,
        userId: json['user_id'] ?? 0,
        description: json['description'] ?? '',
        status: json['status'] ?? 'pending',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'property_id': propertyId,
        'user_id': userId,
        'description': description,
        'status': status
      };
}
