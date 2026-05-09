import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class RegisterFooter extends StatelessWidget {
  const RegisterFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          tr('already_have_account'),
          style: AppTextStyles.font14GreyRegular.copyWith(
            color: AppColors.black,
          ),
        ),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            tr('login_now'),
            style: AppTextStyles.font14OrangeRegular.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
