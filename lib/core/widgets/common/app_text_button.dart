import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/widgets/feedback/app_loading_indicator.dart';

class AppTextButton extends StatelessWidget {
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final TextStyle textStyle;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final double? borderRadius;
  final BorderSide? borderSide;
  final bool? isLoading;

  const AppTextButton({
    super.key,
    this.buttonWidth,
    this.buttonHeight,
    required this.buttonText,
    required this.textStyle,
    this.backgroundColor,
    required this.onPressed,
    this.borderRadius,
    this.borderSide,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular((borderRadius ?? 12.0).r),
            side: borderSide ?? BorderSide.none,
          ),
        ),
        backgroundColor: WidgetStateProperty.all(
          backgroundColor ?? AppColors.primary,
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(
          EdgeInsets.symmetric(horizontal: 12.w, vertical: 0),
        ),
        fixedSize: WidgetStateProperty.all(
          Size(buttonWidth?.w ?? double.maxFinite, buttonHeight?.h ?? 48.h),
        ),
      ),
      onPressed: (isLoading ?? false) ? null : onPressed,
      child: (isLoading ?? false)
          ? const AppLoadingIndicator(size: 24)
          : Text(buttonText, style: textStyle),
    );
  }
}
