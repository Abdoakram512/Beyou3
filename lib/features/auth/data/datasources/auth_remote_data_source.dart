import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String phone,
    required String password,
    required String fcmToken,
  });

  Future<String> register({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
  });

  Future<UserModel> verifyOtp({
    required String phone,
    required String token,
    required String fcmToken,
  });

  Future<void> resendOtp({required String phone});

  Future<void> forgotPassword({required String phone});
  Future<void> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  });
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  String _normalizePhone(String phone) {
    if (phone.startsWith('+200')) {
      phone = '+20${phone.substring(4)}';
    }
    return phone;
  }

  @override
  Future<UserModel> login({
    required String phone,
    required String password,
    required String fcmToken,
  }) async {
    final normalizedPhone = _normalizePhone(phone);
    final response = await apiConsumer.post(
      EndPoints.login,
      data: {
        'phone': normalizedPhone,
        'password': password,
        'fcm_token': fcmToken,
      },
      isFormData: true,
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<String> register({
    required String name,
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final normalizedPhone = _normalizePhone(phone);
    final response = await apiConsumer.post(
      EndPoints.register,
      data: {
        'name': name,
        'phone': normalizedPhone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      isFormData: true,
    );
    return response['message']?.toString() ?? '';
  }

  @override
  Future<UserModel> verifyOtp({
    required String phone,
    required String token,
    required String fcmToken,
  }) async {
    final normalizedPhone = _normalizePhone(phone);
    final response = await apiConsumer.post(
      EndPoints.verifyOtp,
      data: {'phone': normalizedPhone, 'token': token, 'fcm_token': fcmToken},
      isFormData: true,
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<void> resendOtp({required String phone}) async {
    final normalizedPhone = _normalizePhone(phone);
    await apiConsumer.post(
      EndPoints.resendOtp,
      data: {'phone': normalizedPhone},
      isFormData: true,
    );
  }

  @override
  Future<void> forgotPassword({required String phone}) async {
    final normalizedPhone = _normalizePhone(phone);
    await apiConsumer.post(
      EndPoints.forgotPassword,
      data: {'phone': normalizedPhone},
      isFormData: true,
    );
  }

  @override
  Future<void> resetPassword({
    required String phone,
    required String password,
    required String passwordConfirmation,
  }) async {
    final normalizedPhone = _normalizePhone(phone);
    await apiConsumer.post(
      EndPoints.resetPassword,
      data: {
        'phone': normalizedPhone,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
      isFormData: true,
    );
  }

  @override
  Future<void> logout() async {
    await apiConsumer.post(EndPoints.logout);
  }
}
