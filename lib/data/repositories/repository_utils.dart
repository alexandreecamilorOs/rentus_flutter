List<Map<String, dynamic>> extractList(dynamic response) {
  if (response is List) {
    return response.cast<Map<String, dynamic>>();
  }
  if (response is Map<String, dynamic>) {
    final data = response['data'];
    if (data is List) {
      return data.cast<Map<String, dynamic>>();
    }
  }
  return [];
}

Map<String, dynamic> extractMap(dynamic response) {
  if (response is Map<String, dynamic>) {
    final data = response['data'];
    if (data is Map<String, dynamic>) return data;
    return response;
  }
  return {};
}
