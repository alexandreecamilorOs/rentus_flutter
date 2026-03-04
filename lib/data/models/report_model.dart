class Report {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String status;

  Report(
      {required this.id,
      required this.userId,
      required this.title,
      required this.description,
      required this.status});

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json['id'] ?? 0,
        userId: json['user_id'] ?? 0,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        status: json['status'] ?? 'open',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'description': description,
        'status': status
      };
}
