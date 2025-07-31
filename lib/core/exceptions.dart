class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class APIException extends AppException {
  const APIException(super.message);
}

class ValidationException extends AppException {
  const ValidationException(super.message);
}