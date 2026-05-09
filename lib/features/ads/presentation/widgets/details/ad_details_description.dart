import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/theme/app_text_styles.dart';

class AdDetailsDescription extends StatelessWidget {
  final String? description;

  const AdDetailsDescription({super.key, this.description});

  @override
  Widget build(BuildContext context) {
    if (description == null || description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(height: 32.h),
        Text(
          tr('details'),
          style: AppTextStyles.font16GreyRegular.copyWith(
            fontSize: 18.sp,
            color: AppColors.authTitleColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          description!,
          style: AppTextStyles.font14GreyRegular.copyWith(
            fontSize: 15.sp,
            color: AppColors.authSubtitleColor,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
