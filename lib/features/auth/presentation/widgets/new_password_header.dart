import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class NewPasswordHeader extends StatelessWidget {
  final VoidCallback onBack;

  const NewPasswordHeader({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 20.h),
          child: IconButton(
            onPressed: onBack,
            icon: Icon(Icons.arrow_back, color: AppColors.black, size: 32.w),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        SizedBox(height: 12.h),

        // Header Texts
        Text(
          tr('we_reached'),
          style: AppTextStyles.font16BlackSemiBold.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.normal,
            color: AppColors.black,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 16.h),
        Text(
          tr('new_password_title'),
          style: AppTextStyles.font24OrangeBold.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600, // SemiBold
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 12.h),
        Text(
          tr('enter_new_password_subtitle'),
          style: AppTextStyles.font16GreyRegular.copyWith(
            color: const Color(0xFF2B2829),
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }
}
