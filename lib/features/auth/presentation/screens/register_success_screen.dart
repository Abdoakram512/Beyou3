import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/widgets/common/app_text_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RegisterSuccessScreen extends StatelessWidget {
  const RegisterSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              // Back Button
              Align(
                alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: AppColors.greyText,
                    size: 30,
                  ),
                ),
              ),
              const Spacer(),
              // Achievement/Success Icon (Shield inside circles)
              Center(
                child: SvgPicture.asset(
                  AppImages.success,
                  width: 160.w,
                  height: 160.h,
                ),
              ),
              SizedBox(height: 48.h),
              // Success Message
              Text(
                tr('register_success_title'),
                style: AppTextStyles.font24BlackBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),
              Text(
                tr('register_success_subtitle'),
                style: AppTextStyles.font14GreyRegular,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              // Back to Login Button
              AppTextButton(
                buttonText: tr('back_to_login_btn'),
                textStyle: AppTextStyles.font18WhiteSemiBold,
                onPressed: () => context.go('/login'),
                backgroundColor: AppColors.primary,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
