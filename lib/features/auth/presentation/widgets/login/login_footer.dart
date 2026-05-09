import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/common/app_text_button.dart';
import '../../../../../../core/helpers/auth_helper.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextButton(
          buttonText: 'guest_login'.tr(),
          textStyle: AppTextStyles.font18GreenSemiBold,
          onPressed: () {
            AuthHelper.logout();
            context.go('/home');
          },
          backgroundColor: AppColors.white,
          borderSide: const BorderSide(
            color: AppColors.secondaryGreen,
            width: 1,
          ),
        ),
        SizedBox(height: 24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'dont_have_account'.tr(),
              style: AppTextStyles.font14GreyRegular,
            ),
            TextButton(
              onPressed: () => context.push('/register'),
              child: Text(
                'create_new_account'.tr(),
                style: AppTextStyles.font14OrangeRegular.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
