import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import '../widgets/ads_filter_bottom_sheet.dart';

class CategoryAdsSearchAndFilterBar extends StatelessWidget {
  final TextEditingController searchController;
  final String? selectedPurpose;
  final num? minPrice;
  final num? maxPrice;
  final Function(String? purpose, num? min, num? max) onFilterChanged;
  final VoidCallback onSearchChanged;

  const CategoryAdsSearchAndFilterBar({
    super.key,
    required this.searchController,
    this.selectedPurpose,
    this.minPrice,
    this.maxPrice,
    required this.onFilterChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                Icons.tune,
                color: AppColors.primary,
                size: 24.sp,
              ),
              onPressed: () {
                showAdsFilterBottomSheet(
                  context: context,
                  initialPurpose: selectedPurpose,
                  initialMinPrice: minPrice,
                  initialMaxPrice: maxPrice,
                  onApply: onFilterChanged,
                );
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: AppTextFormField(
              controller: searchController,
              hintText: tr('search'),
              backgroundColor: AppColors.lightGrey,
              prefixIcon: Icon(
                Icons.search,
                color: const Color(0xFF8E8E93),
                size: 24.sp,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(16.r),
              ),
              onChanged: (value) => onSearchChanged(),
              validator: (value) => null,
            ),
          ),
        ],
      ),
    );
  }
}
