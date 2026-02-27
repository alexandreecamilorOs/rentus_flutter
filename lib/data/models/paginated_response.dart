class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMeta({required this.currentPage, required this.lastPage, required this.perPage, required this.total});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
        currentPage: json['current_page'] ?? 1,
        lastPage: json['last_page'] ?? 1,
        perPage: json['per_page'] ?? 0,
        total: json['total'] ?? 0,
      );
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResponse({required this.data, required this.meta});

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) mapper) {
    final raw = (json['data'] as List<dynamic>? ?? []);
    final list = raw.map((e) => mapper(e as Map<String, dynamic>)).toList();
    final metaSource = (json['meta'] ?? json) as Map<String, dynamic>;
    return PaginatedResponse(data: list, meta: PaginationMeta.fromJson(metaSource));
  }
}
