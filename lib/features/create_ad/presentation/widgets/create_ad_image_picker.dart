import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';

class CreateAdImagePicker extends StatelessWidget {
  final File? image;
  final bool isMain;
  final String label;
  final VoidCallback onTap;

  const CreateAdImagePicker({
    super.key,
    required this.image,
    required this.isMain,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: isMain ? 180.h : 98.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.imagePickerBackground,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Image.file(image!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    AppIcons.gallery,
                    colorFilter: const ColorFilter.mode(
                      AppColors.imagePickerBorder,
                      BlendMode.srcIn,
                    ),
                    width: 30.w,
                    height: 30.h,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    label,
                    style: AppTextStyles.font12GreyRegular.copyWith(
                      color: AppColors.imagePickerBorder,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
