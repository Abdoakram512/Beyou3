import 'dart:convert';
import 'package:beyou3/core/helpers/shared_pref_helper.dart';
import '../models/app_info_model.dart';
import '../models/faq_model.dart';

class ProfileLocalDataSource {
  static const String _aboutUsKey = 'CACHED_ABOUT_US';
  static const String _privacyPolicyKey = 'CACHED_PRIVACY_POLICY';
  static const String _termsKey = 'CACHED_TERMS';
  static const String _faqsKey = 'CACHED_FAQS';

  Future<void> cacheAboutUs(AppInfoModel model) async {
    await SharedPrefHelper.saveData(
      key: _aboutUsKey,
      value: json.encode(model.toJson()),
    );
  }

  Future<AppInfoModel?> getAboutUs() async {
    final jsonString = SharedPrefHelper.getData(key: _aboutUsKey);
    if (jsonString != null) {
      return AppInfoModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  Future<void> cachePrivacyPolicy(AppInfoModel model) async {
    await SharedPrefHelper.saveData(
      key: _privacyPolicyKey,
      value: json.encode(model.toJson()),
    );
  }

  Future<AppInfoModel?> getPrivacyPolicy() async {
    final jsonString = SharedPrefHelper.getData(key: _privacyPolicyKey);
    if (jsonString != null) {
      return AppInfoModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  Future<void> cacheTerms(AppInfoModel model) async {
    await SharedPrefHelper.saveData(
      key: _termsKey,
      value: json.encode(model.toJson()),
    );
  }

  Future<AppInfoModel?> getTerms() async {
    final jsonString = SharedPrefHelper.getData(key: _termsKey);
    if (jsonString != null) {
      return AppInfoModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  Future<void> cacheFaqs(List<FaqModel> models) async {
    final List<Map<String, dynamic>> jsonList = models
        .map((m) => m.toJson())
        .toList();
    await SharedPrefHelper.saveData(
      key: _faqsKey,
      value: json.encode(jsonList),
    );
  }

  Future<List<FaqModel>?> getFaqs() async {
    final jsonString = SharedPrefHelper.getData(key: _faqsKey);
    if (jsonString != null) {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.map((item) => FaqModel.fromJson(item)).toList();
    }
    return null;
  }
}
