class PaginationMeta {
  final int currentPage;
  final int lastPage;
  final int perPage;
  final int total;

  PaginationMeta(
      {required this.currentPage,
      required this.lastPage,
      required this.perPage,
      required this.total});

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value, int fallback) {
      if (value == null) return fallback;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? fallback;
      return fallback;
    }

    return PaginationMeta(
      currentPage: parseInt(json['current_page'], 1),
      lastPage: parseInt(json['last_page'], 1),
      perPage: parseInt(json['per_page'], 0),
      total: parseInt(json['total'], 0),
    );
  }
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResponse({required this.data, required this.meta});

  factory PaginatedResponse.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) mapper) {
    final raw = (json['data'] as List<dynamic>? ?? []);
    final list = raw.map((e) => mapper(e as Map<String, dynamic>)).toList();
    final metaSource = (json['meta'] ?? json) as Map<String, dynamic>;
    return PaginatedResponse(
        data: list, meta: PaginationMeta.fromJson(metaSource));
  }
}
