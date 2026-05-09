import 'package:easy_localization/easy_localization.dart';
import 'app_regex.dart';

class AppValidators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return tr('required');
    }
    if (!AppRegex.isEmailValid(value)) {
      return tr('enter_email_addr');
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return tr('required');
    }
    if (value.length < 8) {
      return tr('pass_req_length');
    }
    return null;
  }

  static String? validateLoginPassword(String? value) {
    if (value == null || value.isEmpty) {
      return tr('required');
    }
    return null;
  }

  static String? validateConfirmationPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return tr('required');
    }
    if (value != password) {
      return tr('passwords_dont_match');
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return tr('required');
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return tr('required');
    }
    if (!AppRegex.isPhoneNumberValid(value)) {
      return tr('phone_info');
    }
    return null;
  }

  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return tr('required');
    }
    if (value.length < 5) {
      return tr('please_verify_phone');
    }
    return null;
  }

  static String convertArabicToEnglishNumbers(String input) {
    const arabicNumbers = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    const englishNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

    for (int i = 0; i < arabicNumbers.length; i++) {
      input = input.replaceAll(arabicNumbers[i], englishNumbers[i]);
    }
    return input;
  }
}
