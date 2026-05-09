import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_colors.dart';
import '../theme/app_images.dart';

class CopyrightWidget extends StatelessWidget {
  final bool showCopyrightText;
  final Color? logoColor;
  final double? designedByFontSize;
  final double? copyrightFontSize;
  final double? logoHeight;
  final double? logoWidth;

  const CopyrightWidget({
    super.key,
    this.showCopyrightText = true,
    this.logoColor,
    this.designedByFontSize,
    this.copyrightFontSize,
    this.logoHeight,
    this.logoWidth,
  });

  Future<void> _launchBrmjaWebsite() async {
    final Uri url = Uri.parse('https://brmja.tech/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _launchBrmjaWebsite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // "Designed & Developed by" label
          Text(
            'designedAndDevelopedBy'.tr(),
            style: TextStyle(
              fontSize: designedByFontSize ?? 12.sp,
              color: AppColors.greyText.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 8.h),

          // Brmja Logo
          SizedBox(
            height: logoHeight ?? 30.h,
            width: logoWidth ?? 150.w,
            child: Image.asset(AppImages.copyRight, color: logoColor),
          ),

          if (showCopyrightText) ...[
            Text(
              'copyright'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: copyrightFontSize ?? 12.sp,
                color: AppColors.greyText.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
