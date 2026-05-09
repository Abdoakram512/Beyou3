import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          tr('register_title'),
          style: AppTextStyles.font24BlackBold,
        ),
        SizedBox(height: 12.h),
        Text(
          tr('auth_subtitle'),
          style: AppTextStyles.font14GreyRegular,
        ),
      ],
    );
  }
}
