class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;
  final String type;
  final DateTime? createdAt;
  final Map<String, dynamic> data;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    this.type = 'system',
    this.createdAt,
    this.data = const {},
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> nestedData = json['data'] is Map<String, dynamic>
        ? json['data']
        : (json['data'] is String
            ? {}
            : <String, dynamic>{}); // Si el data es un string, lo ignoramos

    return NotificationModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title'] ?? nestedData['title'] ?? 'Notificación',
      body: json['message'] ?? json['body'] ?? nestedData['message'] ?? '',
      isRead: json['is_read'] ?? json['read'] ?? (json['read_at'] != null),
      type: json['type'] ?? nestedData['type'] ?? 'system',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      data: nestedData,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'is_read': isRead,
        'type': type,
        'created_at': createdAt?.toIso8601String(),
        'data': data,
      };
}
