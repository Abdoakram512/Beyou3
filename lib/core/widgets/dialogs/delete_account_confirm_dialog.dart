import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/common/app_text_button.dart';

class DeleteAccountConfirmDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteAccountConfirmDialog({super.key, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        tween: Tween(begin: 0.0, end: 1.0),
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20.w,
                spreadRadius: 5.w,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_forever_rounded,
                  size: 48.w,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'delete_account'.tr(),
                style: AppTextStyles.font20BrownSemiBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'delete_account_confirmation'.tr(),
                style: AppTextStyles.font16ProfileGreyMedium.copyWith(
                  height: 1.5,
                  color: const Color(0xFF636366),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              AppTextButton(
                buttonText: 'delete'.tr(),
                textStyle: AppTextStyles.font16WhiteSemiBold,
                onPressed: () {
                  context.pop();
                  onDelete();
                },
                backgroundColor: AppColors.error,
                buttonHeight: 56.h,
                borderRadius: 16.r,
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'cancel'.tr(),
                  style: AppTextStyles.font16ProfileGreyMedium.copyWith(
                    color: const Color(0xFF636366),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context, {required VoidCallback onDelete}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => DeleteAccountConfirmDialog(onDelete: onDelete),
    );
  }
}
