import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF202954).withValues(alpha: 0.40),
              const Color(0xFF202954).withValues(alpha: 0.74),
              const Color(0xFF202954),
            ],
          ).createShader(bounds),
          child: Text(
            'welcome'.tr(),
            style: AppTextStyles.font36AuthTitle,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'welcome_subtitle'.tr(),
          style: AppTextStyles.font14AuthSubtitle,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
