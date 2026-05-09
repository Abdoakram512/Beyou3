import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/profile/data/models/profile_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel? user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(35.r),
              child: user?.image != null && user!.image!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: user!.image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const AppLoadingIndicator(size: 30),
                      errorWidget: (context, url, error) =>
                          _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Aligns to the right in RTL
            children: [
              Text(
                user?.name ?? "guest".tr(),
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.authTitleColor,
                ),
              ),
              SizedBox(height: 4.h),
              if (user != null)
                Text(
                  user!.phone ?? '',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.greyText),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: Icon(Icons.person, size: 40.w, color: AppColors.primary),
    );
  }
}
