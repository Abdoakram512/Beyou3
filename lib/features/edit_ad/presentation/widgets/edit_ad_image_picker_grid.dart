import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../ads/domain/entities/ad_details_entity.dart';

class EditAdImagePickerGrid extends StatelessWidget {
  final List<AdImageEntity> existingImages;
  final List<File> newImages;
  final VoidCallback onPickImage;
  final Function(int) onRemoveExisting;
  final Function(int) onRemoveNew;

  const EditAdImagePickerGrid({
    super.key,
    required this.existingImages,
    required this.newImages,
    required this.onPickImage,
    required this.onRemoveExisting,
    required this.onRemoveNew,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w,
      ),
      itemCount: existingImages.length + newImages.length + 1,
      itemBuilder: (context, index) {
        if (index == existingImages.length + newImages.length) {
          return _buildAddButton();
        }

        final isExisting = index < existingImages.length;
        final isMain = index == 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            _buildImageCard(index, isExisting),
            if (isMain) _buildMainBadge(),
            _buildDeleteButton(index, isExisting),
          ],
        );
      },
    );
  }

  Widget _buildAddButton() {
    return InkWell(
      onTap: onPickImage,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey, width: 1.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: AppColors.primary,
              size: 24.w,
            ),
            SizedBox(height: 4.h),
            Text(
              tr('add_image'),
              style: AppTextStyles.font12GreyRegular.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(int index, bool isExisting) {
    final ImageProvider imageProvider = isExisting
        ? NetworkImage(existingImages[index].url) as ImageProvider
        : FileImage(newImages[index - existingImages.length]) as ImageProvider;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildMainBadge() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.8),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12.r),
            bottomRight: Radius.circular(12.r),
          ),
        ),
        child: Text(
          tr('main_image_badge'),
          textAlign: TextAlign.center,
          style: AppTextStyles.font10WhiteBold,
        ),
      ),
    );
  }

  Widget _buildDeleteButton(int index, bool isExisting) {
    return Positioned(
      top: -4.w,
      right: -4.w,
      child: InkWell(
        onTap: () => isExisting
            ? onRemoveExisting(index)
            : onRemoveNew(index - existingImages.length),
        child: Container(
          padding: EdgeInsets.all(4.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.close, color: Colors.red, size: 14.w),
        ),
      ),
    );
  }
}
