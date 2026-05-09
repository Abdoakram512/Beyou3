import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';

class HowWeWorkScreen extends StatelessWidget {
  const HowWeWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: tr('how_we_work')),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildHowSection(
              "1. ${tr('browse_ads')}",
              tr('browse_ads_content'),
            ),
            _buildHowSection(
              "2. ${tr('contact_seller')}",
              tr('contact_seller_content'),
            ),
            _buildHowSection("3. ${tr('make_deal')}", tr('make_deal_content')),
            _buildHowSection(
              "4. ${tr('rate_experience')}",
              tr('rate_experience_content'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.greyText,
              height: 1.5,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
