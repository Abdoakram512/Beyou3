import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/app_text_button.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/ad_entity.dart';

class AdCard extends StatelessWidget {
  final AdEntity ad;

  const AdCard({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    // Determine purpose color and text
    final bool isRent = ad.purpose?.toLowerCase() == 'rent';
    final Color purposeColor = isRent
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF9800);
    final String purposeText = isRent ? tr('for_rent') : tr('for_sale');

    // ✅ Fix 3.1: Removed outer GestureDetector to prevent double navigation
    return Container(
      width: 0.45.sw,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                child: CachedNetworkImage(
                  imageUrl:
                      ad.image ??
                      "https://placehold.co/170x120/ECEFF1/B0BEC5/png",
                  height: 0.15.sh,
                  width: double.infinity,
                  memCacheWidth:
                      (0.45.sw * MediaQuery.of(context).devicePixelRatio)
                          .toInt(),
                  memCacheHeight:
                      (0.15.sh * MediaQuery.of(context).devicePixelRatio)
                          .toInt(),
                  maxWidthDiskCache: 400,
                  maxHeightDiskCache: 300,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 500),
                  placeholder: (context, url) => Container(
                    height: 0.15.sh,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.lightGrey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r),
                      ),
                    ),
                    child: const AppLoadingIndicator(),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 0.15.sh,
                    width: double.infinity,
                    color: AppColors.lightGrey,
                    child: const Icon(Icons.error),
                  ),
                ),
              ),
              // Featured Badge
              if (ad.isFeatured)
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB9F6CA),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      tr('featured'),
                      style: AppTextStyles.font12GreyRegular.copyWith(
                        fontSize: 10.sp,
                        color: const Color(0xFF388E3C),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              // Purpose Badge (Sale/Rent)
              if (ad.purpose != null)
                Positioned(
                  top: 8.h,
                  left: 8.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: purposeColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      purposeText,
                      style: AppTextStyles.font14WhiteSemiBold.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Details
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 35.h, // Fixed height for two lines of text
                  child: Text(
                    ad.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font14GreyRegular.copyWith(
                      fontSize: 13.sp,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      ad.price.formatPrice,
                      style: AppTextStyles.font14OrangeRegular.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      tr('egp'),
                      style: AppTextStyles.font12GreyRegular.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  child: AppTextButton(
                    buttonText: tr('view_details'),
                    textStyle: AppTextStyles.font14WhiteSemiBold.copyWith(
                      fontSize: 12.sp,
                    ),
                    onPressed: () {
                      context.push('/ad-details/${ad.id}');
                    },
                    buttonHeight: 36, // Slightly more compact
                    borderRadius: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
