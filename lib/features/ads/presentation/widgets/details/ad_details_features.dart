import 'package:beyou3/features/ads/domain/entities/ad_details_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class AdDetailsFeatures extends StatelessWidget {
  final AdDetailsEntity ad;

  const AdDetailsFeatures({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        if (ad.purpose != null && ad.purpose!.isNotEmpty)
          _buildFeatureChip(
            context,
            tr('purpose_detail_label'),
            tr(ad.purpose!.toLowerCase()),
          ),
        if (ad.area != null && ad.area!.isNotEmpty)
          _buildFeatureChip(
            context,
            tr('area_detail_label'),
            '${ad.area} ${tr('meter')}',
          ),
      ],
    );
  }

  Widget _buildFeatureChip(
    BuildContext context,
    String label,
    String value, {
    bool isStatus = false,
  }) {
    Color chipColor = Colors.grey.withValues(alpha: 0.1);
    Color borderColor = Colors.grey.withValues(alpha: 0.2);
    Color labelColor = Colors.grey[600]!;
    Color valueColor = AppColors.primary;

    if (isStatus) {
      if (value.toLowerCase() == tr('active').toLowerCase() ||
          value.toLowerCase() == 'active' ||
          value.toLowerCase() == tr('approved').toLowerCase()) {
        chipColor = Colors.green.withValues(alpha: 0.1);
        borderColor = Colors.green.withValues(alpha: 0.3);
        labelColor = Colors.green[800]!;
        valueColor = Colors.green[800]!;
      } else if (value.toLowerCase() == tr('pending_review').toLowerCase() ||
          value.toLowerCase() == 'pending') {
        chipColor = Colors.amber.withValues(alpha: 0.1);
        borderColor = Colors.amber.withValues(alpha: 0.3);
        labelColor = Colors.amber[800]!;
        valueColor = Colors.amber[800]!;
      } else if (value.toLowerCase() == tr('rejected').toLowerCase() ||
          value.toLowerCase() == 'rejected') {
        chipColor = Colors.red.withValues(alpha: 0.1);
        borderColor = Colors.red.withValues(alpha: 0.3);
        labelColor = Colors.red[800]!;
        valueColor = Colors.red[800]!;
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
