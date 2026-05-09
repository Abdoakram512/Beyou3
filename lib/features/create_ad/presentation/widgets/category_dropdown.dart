import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../categories/domain/entities/category_entity.dart';

class CategoryDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final List<CategoryEntity> items;
  final bool isLoading;
  final CategoryEntity? selectedItem;
  final ValueChanged<CategoryEntity?> onChanged;

  const CategoryDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.isLoading,
    required this.selectedItem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.font14BlackRegular),
        SizedBox(height: 8.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading ? _buildLoadingIndicator() : _buildDropdown(),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      key: const ValueKey('loading'),
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 2.w),
            Text(tr('loading'), style: AppTextStyles.font14GreyRegular),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    final effectiveValue =
        (selectedItem != null && items.any((e) => e.id == selectedItem!.id))
        ? selectedItem
        : null;

    return DropdownButtonFormField<CategoryEntity>(
      key: ValueKey('dropdown_${items.length}_${items.hashCode}'),
      value: effectiveValue,
      alignment: Alignment.center,
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.greyText,
        size: 24.w,
      ),
      hint: Center(
        child: Text(
          hint,
          style: AppTextStyles.font14GreyRegular,
          textAlign: TextAlign.center,
        ),
      ),
      isExpanded: true,
      items: items.map((CategoryEntity item) {
        return DropdownMenuItem<CategoryEntity>(
          value: item,
          alignment: Alignment.center,
          child: Text(
            item.name,
            style: AppTextStyles.font14BlackRegular,
            textAlign: TextAlign.center,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        isDense: true,
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.w),
          child: SvgPicture.asset(
            AppIcons.star,
            width: 15.w,
            height: 15.w,
            fit: BoxFit.scaleDown,
            colorFilter: const ColorFilter.mode(
              AppColors.greyText,
              BlendMode.srcIn,
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 32.w, minHeight: 32.w),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.borderGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }
}
