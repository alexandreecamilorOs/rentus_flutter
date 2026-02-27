class NotificationModel {
  final int id;
  final String title;
  final String body;
  final bool isRead;

  NotificationModel({required this.id, required this.title, required this.body, required this.isRead});

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] ?? 0,
        title: json['title'] ?? json['data']?['title'] ?? 'Notificación',
        body: json['body'] ?? json['data']?['message'] ?? '',
        isRead: json['is_read'] ?? (json['read_at'] != null),
      );

  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'body': body, 'is_read': isRead};
}
