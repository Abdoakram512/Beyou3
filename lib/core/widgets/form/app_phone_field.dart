import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/theme/app_text_styles.dart';

class AppPhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? labelText;
  final FocusNode? focusNode;
  final void Function(PhoneNumber)? onChanged;
  final String initialCountryCode;
  final String? Function(PhoneNumber?)? validator;
  final int? maxLength;
  final bool readOnly;
  final bool enabled;

  const AppPhoneField({
    super.key,
    this.controller,
    required this.hintText,
    this.labelText,
    this.focusNode,
    this.onChanged,
    this.initialCountryCode = 'EG',
    this.validator,
    this.maxLength = 11,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(labelText!, style: AppTextStyles.font16BlackMedium),
          SizedBox(height: 8.h),
        ],
        IntlPhoneField(
          controller: controller,
          focusNode: focusNode,
          readOnly: readOnly,
          enabled: enabled,
          initialCountryCode: initialCountryCode,
          onChanged: onChanged,
          validator: validator,
          style: AppTextStyles.font14BlackRegular,
          dropdownTextStyle: AppTextStyles.font14BlackRegular,
          showDropdownIcon: true,
          dropdownIconPosition: IconPosition.trailing,
          flagsButtonPadding: EdgeInsets.symmetric(horizontal: 8.w),
          inputFormatters: [LengthLimitingTextInputFormatter(maxLength ?? 11)],
          disableLengthCheck: true,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
            hintText: hintText,
            hintStyle: AppTextStyles.font14GreyRegular,
            fillColor: AppColors.white,
            filled: true,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 1.0.w),
              borderRadius: BorderRadius.circular(6.r),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.fieldBorder,
                width: 1.0.w,
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.fieldBorder,
                width: 1.0.w,
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0.w),
              borderRadius: BorderRadius.circular(6.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 1.0.w),
              borderRadius: BorderRadius.circular(6.r),
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }
}
