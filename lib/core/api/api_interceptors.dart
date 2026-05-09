import 'package:dio/dio.dart';
import '../helpers/app_logger.dart';
import '../helpers/auth_helper.dart';
import '../helpers/shared_pref_helper.dart';
import 'end_points.dart';

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Set common headers
    final language = SharedPrefHelper.getData(key: 'language') ?? 'ar';
    options.headers['Accept'] = 'application/json';
    options.headers['Accept-Language'] = language;

    // 2. Define endpoints that don't require a token
    final noAuthEndpoints = [
      EndPoints.login,
      EndPoints.register,
      EndPoints.verifyOtp,
      EndPoints.resendOtp,
      EndPoints.forgotPassword,
      EndPoints.resetPassword,
    ];

    // 3. Only attach token if not an auth endpoint
    final isAuthEndpoint = noAuthEndpoints.any(
      (endpoint) =>
          options.path == endpoint || options.path == endpoint.substring(1),
    );

    if (!isAuthEndpoint) {
      final token = await AuthHelper.getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        options.headers.remove('Authorization');
      }
    }

    AppLogger.log(
      '--> Request [${options.method}] ${options.path}',
      name: 'API_REQUEST',
    );
    AppLogger.log('--> Headers: ${options.headers}', name: 'API_HEADERS');

    // 4. Continue with the request
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // If we get a 401, perform logout
    if (err.response?.statusCode == 401 &&
        err.requestOptions.path != EndPoints.login) {
      AuthHelper.logout();
    }

    // Do NOT logout on 403, just let the error pass through
    return handler.next(err);
  }
}
