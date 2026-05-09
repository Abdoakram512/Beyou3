import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/widgets/common/app_text_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              // Success Icon (Jagged circle like screenshot)
              Center(
                child: SvgPicture.asset(
                  AppImages.success,
                  width: 160.w,
                  height: 160.h,
                ),
              ),
              SizedBox(height: 48.h),
              // Success Text
              Text(
                tr('pass_changed_success'),
                style: AppTextStyles.font24BlackBold.copyWith(fontSize: 28.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                tr('can_login_now'),
                style: AppTextStyles.font14GreyRegular,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Back to Login Button
              AppTextButton(
                buttonText: tr('back_to_login'),
                textStyle: AppTextStyles.font18WhiteSemiBold,
                onPressed: () => context.go('/login'),
                backgroundColor: AppColors.primary,
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}
