import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationItem extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        // ✅ Fix 2.2: Unread → tinted background, Read → white
        color: notification.isRead
            ? Colors.white
            : AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: notification.isRead
            ? null
            : Border.all(
                color: AppColors.primary.withValues(alpha: 0.15),
                width: 1,
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ✅ Fix 2.2: Unread dot indicator
              if (!notification.isRead) ...[
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Expanded(
                child: Text(
                  notification.title,
                  style: notification.isRead
                      ? AppTextStyles.font16BlackMedium
                      : AppTextStyles.font16BlackMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                ),
              ),
              Text(
                notification.createdAt,
                style: AppTextStyles.font12GreyRegular,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: notification.isRead ? 0 : 16.w,
            ),
            child: Text(
              notification.body,
              style: AppTextStyles.font14GreyRegular,
            ),
          ),
        ],
      ),
    );
  }
}

