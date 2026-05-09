import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_text_styles.dart';

class EditAdSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const EditAdSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, size: 20.w, color: Theme.of(context).primaryColor),
          SizedBox(width: 8.w),
          Text(
            tr(title),
            style: AppTextStyles.font16BlackMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
