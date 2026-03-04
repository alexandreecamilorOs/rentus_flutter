class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class UnauthorizedException extends ApiException {
  UnauthorizedException([super.message = 'No autorizado']) : super(statusCode: 401);
}

class ForbiddenException extends ApiException {
  ForbiddenException([super.message = 'Acceso denegado']) : super(statusCode: 403);
}

class ServerException extends ApiException {
  ServerException([super.message = 'Error interno del servidor']) : super(statusCode: 500);
}
