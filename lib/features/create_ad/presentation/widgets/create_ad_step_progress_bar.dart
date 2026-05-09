import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class CreateAdStepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const CreateAdStepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isActive = index == currentStep;
          final isCompleted = index < currentStep;

          return Expanded(
            child: Container(
              height: 8.h,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: isActive || isCompleted
                    ? AppColors.primary
                    : const Color(0xFFE8E8FF),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }),
      ),
    );
  }
}
