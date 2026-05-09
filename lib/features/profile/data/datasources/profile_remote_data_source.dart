import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/profile_model.dart';
import 'package:dio/dio.dart';
import '../models/app_info_model.dart';
import '../models/faq_model.dart';

class ProfileRemoteDataSource {
  final ApiConsumer apiConsumer;

  ProfileRemoteDataSource({required this.apiConsumer});

  Future<ProfileModel> getProfile() async {
    final response = await apiConsumer.get(EndPoints.profile);
    return ProfileModel.fromJson(response);
  }

  Future<ProfileModel> updateProfile(Map<String, dynamic> data) async {
    if (data.containsKey('image') && data['image'] != null) {
      data['image'] = await MultipartFile.fromFile(data['image'] as String);
    }

    final response = await apiConsumer.post(
      EndPoints.profile,
      data: data,
      isFormData: true,
    );
    return ProfileModel.fromJson(response);
  }

  Future<void> deleteAccount() async {
    await apiConsumer.get(EndPoints.deleteProfile);
  }

  Future<void> sendContactMessage(String subject, String message) async {
    await apiConsumer.post(
      EndPoints.contactUs,
      data: {'subject': subject, 'message': message},
    );
  }

  Future<AppInfoModel> getAboutUs() async {
    final response = await apiConsumer.get(EndPoints.aboutUs);
    return AppInfoModel.fromJson(response['data']);
  }

  Future<AppInfoModel> getPrivacyPolicy() async {
    final response = await apiConsumer.get(EndPoints.privacyPolicy);
    return AppInfoModel.fromJson(response['data']);
  }

  Future<AppInfoModel> getTerms() async {
    final response = await apiConsumer.get(EndPoints.terms);
    return AppInfoModel.fromJson(response['data']);
  }

  Future<List<FaqModel>> getFaqs() async {
    final response = await apiConsumer.get(EndPoints.faqs);
    return (response['data'] as List).map((e) => FaqModel.fromJson(e)).toList();
  }
}
