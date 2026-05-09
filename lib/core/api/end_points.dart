import '../config/app_config.dart';

class EndPoints {
  static const String baseUrl = AppConfig.baseUrl;

  static const String login = '/login';
  static const String register = '/register';
  static const String verifyOtp = '/verify-otp';
  static const String resendOtp = '/resend-otp';
  static const String forgotPassword = '/forgot/password';
  static const String resetPassword = '/forgot/reset-password';
  static const String logout = '/logout';
  static const String categories = '/categories';
  static const String banners = '/banners';
  static const String profile = '/profile';
  static const String updateProfile = '/profile/update';
  static const String deleteProfile = '/delete_account';
  static const String contactUs = '/contact';
  static const String aboutUs = '/about-us';
  static const String privacyPolicy = '/privacy';
  static const String terms = '/terms';
  static const String faqs = '/faq';
  static const String ads = '/ads';
  static const String myAds = '/my-ads';
  static const String brands = '/brands';
  static const String updateAds = '/update-ads';
  static const String notifications = '/notifications';
}
