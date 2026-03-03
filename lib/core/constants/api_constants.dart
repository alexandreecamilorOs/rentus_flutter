class ApiConstants {
  static const baseUrl =
      'https://backend-rentus-production-e937.up.railway.app/api';

  // Token de prueba temporal (no usar en producción).
  // Se puede sobreescribir con --dart-define=RENTUS_DEMO_JWT=...
  static const demoJwt =
      String.fromEnvironment('RENTUS_DEMO_JWT', defaultValue: '');
}
