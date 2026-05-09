/// Server returned a non-successful status code with an optional message.
class ServerException implements Exception {
  final String? message;
  final int? code;
  final Map<String, dynamic>? data;
  const ServerException([this.message, this.code, this.data]);
}

/// No connectivity or connection timed out.
class NetworkException implements Exception {
  const NetworkException();
}

/// 401 / 403 — caller is not authenticated / authorized.
class AuthException implements Exception {
  const AuthException();
}

/// 422 — validation errors from the server.
class ValidationException implements Exception {
  final String message;
  const ValidationException(this.message);
}

/// 404 — requested resource does not exist.
class NotFoundException implements Exception {
  const NotFoundException();
}

/// Unrecognised or unexpected error.
class UnknownException implements Exception {
  const UnknownException();
}

/// Local cache read/write failure.
class CacheException implements Exception {
  final String message;
  const CacheException(this.message);
}
