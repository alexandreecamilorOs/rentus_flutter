import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConstants {
  static const baseUrl =
      'https://backend-rentus-production-e937.up.railway.app/api';

  // Token de prueba temporal (no usar en producción).
  // Se puede sobreescribir con --dart-define=RENTUS_DEMO_JWT=...
  static const demoJwt =
      String.fromEnvironment('RENTUS_DEMO_JWT', defaultValue: '');

  static String resolveUrl(dynamic path) {
    if (path == null || path is! String || path.isEmpty) return '';

    // If it's an R2 bucket URL and we're on web, proxy it to bypass CORS CanvasKit blocks.
    if (kIsWeb && path.toString().contains('r2.dev')) {
      return 'https://corsproxy.io/?${Uri.encodeComponent(path)}';
    }

    if (path.startsWith('http')) return path;

    // Ensure path starts with /
    final normalizedPath = path.startsWith('/') ? path : '/$path';

    // Laravel specific: If it doesn't have /storage/, prepend it
    String cleanPath = normalizedPath;
    if (!normalizedPath.startsWith('/storage/') &&
        !normalizedPath.startsWith('/public/')) {
      cleanPath = '/storage$normalizedPath';
    }

    // Remove /api from end of base URL for storage paths
    final root = baseUrl.replaceAll('/api', '');
    return '$root$cleanPath';
  }
}
