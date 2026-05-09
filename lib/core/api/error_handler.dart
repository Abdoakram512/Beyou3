import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

import '../error/error_model.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';

// ─── Repository helper ────────────────────────────────────────────────────────
/// Wraps any data-source call and maps every known exception to a [Failure].
/// Use this in every repository — zero try/catch boilerplate needed anywhere else.
///
/// ```dart
/// Future<Either<Failure, UserModel>> getProfile() =>
///     safeCall(remoteDataSource.getProfile);
/// ```
Future<Either<Failure, T>> safeCall<T>(Future<T> Function() call) async {
  try {
    return Right(await call());
  } on NetworkException {
    return Left(NetworkFailure(tr('network_error')));
  } on AuthException {
    return Left(AuthFailure(tr('auth_error')));
  } on ValidationException catch (e) {
    return Left(ValidationFailure(e.message));
  } on NotFoundException {
    return Left(NotFoundFailure(tr('not_found_error')));
  } on ServerException catch (e) {
    return Left(
      ServerFailure(
        e.message ?? tr('server_error_msg'),
        data: e.data,
        code: e.code,
      ),
    );
  } on CacheException catch (e) {
    return Left(CacheFailure(e.message));
  } catch (_) {
    return Left(UnknownFailure(tr('unknown_error')));
  }
}

// ─── Dio error handler ────────────────────────────────────────────────────────
/// Maps [DioException] → typed [Exception].
/// Called exclusively from [DioConsumer]; not needed anywhere else.
class ErrorHandler {
  // Prevent instantiation.
  ErrorHandler._();

  static Exception fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        return _fromStatusCode(e.response);
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
        return const UnknownException();
    }
  }

  static Exception _fromStatusCode(Response? response) {
    if (response == null) return const UnknownException();

    final data = response.data is Map<String, dynamic>
        ? response.data as Map<String, dynamic>
        : <String, dynamic>{};

    switch (response.statusCode) {
      case 400:
        return ServerException(ErrorModel.fromJson(data).errorMessage);
      case 401:
      case 403:
        return const AuthException();
      case 404:
        return const NotFoundException();
      case 422:
        return ValidationException(ErrorModel.fromJson(data).errorMessage);
      case 500:
        return const ServerException();
      case 415:
        final errorModel = ErrorModel.fromJson(data);
        return ServerException(
          errorModel.errorMessage,
          response.statusCode,
          errorModel.data,
        );
      case 503:
        return ServerException(tr('service_unavailable'));
      default:
        return const UnknownException();
    }
  }

  // ─── Message resolver ───────────────────────────────────────────────────────
  /// Returns the Arabic user-facing message for a given [Failure].
  static String getMessage(Failure failure) {
    if (failure is NetworkFailure) return tr('network_error');
    if (failure is AuthFailure) return tr('auth_error');
    if (failure is NotFoundFailure) return tr('not_found_error');
    if (failure is ValidationFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : tr('validation_error');
    }
    if (failure is ServerFailure) {
      return failure.message.isNotEmpty
          ? failure.message
          : tr('server_error_msg');
    }
    if (failure is CacheFailure) return tr('cache_error');
    return tr('unknown_error');
  }
}
