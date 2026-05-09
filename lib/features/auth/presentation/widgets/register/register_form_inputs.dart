import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/common/app_text_form_field.dart';
import '../../../../../../core/widgets/form/app_phone_field.dart';
import '../../../../../../core/helpers/app_validators.dart';
import '../auth_password_field.dart';
import '../password_validator_widget.dart';

class RegisterFormInputs extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode phoneFocusNode;
  final Function(String) onPhoneChanged;

  const RegisterFormInputs({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneFocusNode,
    required this.onPhoneChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            tr('full_name'),
            style: AppTextStyles.font14GreyRegular.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        AppTextFormField(
          controller: nameController,
          hintText: tr('enter_full_name'),
          prefixIcon: const Icon(Icons.person_outline, color: AppColors.grey),
          validator: AppValidators.validateName,
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            tr('phone_number'),
            style: AppTextStyles.font14GreyRegular.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        AppPhoneField(
          controller: phoneController,
          hintText: tr('enter_phone_number'),
          focusNode: phoneFocusNode,
          validator: (phone) {
            if (phone == null || phone.number.isEmpty) {
              return tr('required');
            }
            return null;
          },
          onChanged: (phone) {
            final engNumber = AppValidators.convertArabicToEnglishNumbers(
              phone.number,
            );
            final number = engNumber.startsWith('0')
                ? engNumber.substring(1)
                : engNumber;
            onPhoneChanged('+${phone.countryCode.replaceAll('+', '')}$number');
          },
        ),
        SizedBox(height: 16.h),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            tr('password'),
            style: AppTextStyles.font14GreyRegular.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        AuthPasswordField(
          controller: passwordController,
          hintText: tr('password'),
          validator: AppValidators.validatePassword,
        ),
        PasswordValidatorWidget(controller: passwordController),
        SizedBox(height: 16.h),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            tr('confirm_new_password_label'),
            style: AppTextStyles.font14GreyRegular.copyWith(
              color: AppColors.black,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        AuthPasswordField(
          controller: confirmPasswordController,
          hintText: tr('confirm_new_password_label'),
          validator: (val) => AppValidators.validateConfirmationPassword(
            val,
            passwordController.text,
          ),
        ),
      ],
    );
  }
}
