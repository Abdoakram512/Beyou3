import 'package:beyou3/core/helpers/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/theme/app_text_styles.dart';
import 'package:beyou3/features/ads/domain/entities/ad_details_entity.dart';

class AdDetailsInfoSection extends StatelessWidget {
  final AdDetailsEntity ad;

  const AdDetailsInfoSection({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${ad.price.formatPrice} ${tr('egp')}",
          style: AppTextStyles.font24OrangeBold.copyWith(fontSize: 26.sp),
        ),
        SizedBox(height: 12.h),
        Text(ad.title, style: AppTextStyles.font20AuthSectionTitle),
        SizedBox(height: 16.h),
        _buildLocationRow(),
        if (ad.createdAt != null) ...[SizedBox(height: 6.h), _buildTimeRow()],
      ],
    );
  }

  Widget _buildLocationRow() {
    final address = ad.location?.address;
    final hasAddress = address != null && address.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.location_on_outlined, color: AppColors.greyText, size: 18.w),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            hasAddress ? address : tr('unknown_location'),
            style: AppTextStyles.font14GreyRegular,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRow() {
    return Row(
      children: [
        Icon(Icons.access_time, color: AppColors.greyText, size: 16.w),
        SizedBox(width: 4.w),
        Text(ad.createdAt!, style: AppTextStyles.font12GreyRegular),
      ],
    );
  }
}
