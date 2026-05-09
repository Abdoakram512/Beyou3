import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class PasswordValidatorWidget extends StatelessWidget {
  final TextEditingController controller;

  const PasswordValidatorWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final text = value.text;
        final isLengthValid = text.length >= 8;
        final isComplexityValid =
            text.contains(RegExp(r'[A-Z]')) &&
            text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

        return Column(
          children: [
            SizedBox(height: 16.h),
            _buildValidationRule(tr('pass_req_length'), isLengthValid),
            SizedBox(height: 12.h),
            _buildValidationRule(tr('pass_req_symbols'), isComplexityValid),
          ],
        );
      },
    );
  }

  Widget _buildValidationRule(String label, bool isValid) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isValid ? 2.w : 4.w),
          decoration: BoxDecoration(
            color: isValid ? AppColors.success : AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            isValid ? Icons.check : Icons.circle,
            color: Colors.white,
            size: isValid ? 14.sp : 6.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.font14OrangeRegular.copyWith(
              color: isValid ? AppColors.success : AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
