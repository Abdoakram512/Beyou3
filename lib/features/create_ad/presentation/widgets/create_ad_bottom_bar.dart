import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/app_text_button.dart';

class CreateAdBottomBar extends StatelessWidget {
  final int currentStep;
  final bool isLoading;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const CreateAdBottomBar({
    super.key,
    required this.currentStep,
    required this.isLoading,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    final isLastStep = currentStep == 2;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: AppTextButton(
                buttonText: isLoading
                    ? tr('publishing')
                    : (isLastStep ? tr('publish_ad') : tr('next_btn')),
                textStyle: AppTextStyles.font16WhiteSemiBold,
                backgroundColor: AppColors.primary,
                onPressed: onNext,
                isLoading: isLoading,
              ),
            ),
            if (currentStep > 0) ...[
              SizedBox(width: 12.w),
              Expanded(
                child: AppTextButton(
                  buttonText: tr('previous_btn'),
                  textStyle: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                  backgroundColor: AppColors.white,
                  borderSide: const BorderSide(color: AppColors.borderGrey),
                  onPressed: onPrevious,
                  isLoading: isLoading,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
