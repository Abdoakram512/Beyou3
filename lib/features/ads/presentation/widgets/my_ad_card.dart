import 'package:beyou3/core/helpers/extensions.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/ad_entity.dart';

class MyAdCard extends StatelessWidget {
  final AdEntity ad;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const MyAdCard({super.key, required this.ad, this.onTap, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        height: 130.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Section
              CachedNetworkImage(
                imageUrl:
                    ad.image ??
                    'https://placehold.co/600x400/EEE/31343C?text=No+Image',
                width: 120.w,
                height: 130.h,
                memCacheWidth: (300 * MediaQuery.of(context).devicePixelRatio)
                    .toInt(),
                memCacheHeight: (300 * MediaQuery.of(context).devicePixelRatio)
                    .toInt(),
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 120.w,
                  color: AppColors.lightGrey,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 120.w,
                  color: AppColors.lightGrey,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.greyText,
                  ),
                ),
              ),

              // Details Section
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatusBadge(ad.status),
                              Text(
                                ad.createdAt ?? '',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.greyText,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            ad.title,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.authTitleColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (ad.category != null) ...[
                            SizedBox(height: 4.h),
                            Text(
                              ad.category!.name,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.greyText,
                              ),
                            ),
                          ],
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${ad.price.formatPrice} ${tr('egp')}",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          GestureDetector(
                            onTap: onEdit,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: AppColors.lightGrey.withValues(
                                  alpha: 0.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 16.w,
                                color: AppColors.greyText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String? status) {
    Color color;
    String label;

    switch (status?.toLowerCase()) {
      case 'approved':
      case 'active':
        color = AppColors.success;
        label = tr('approved');
        break;
      case 'rejected':
      case 'refused':
        color = AppColors.error;
        label = tr('rejected');
        break;
      case 'pending':
      default:
        color = AppColors.primary;
        label = tr('pending');
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
