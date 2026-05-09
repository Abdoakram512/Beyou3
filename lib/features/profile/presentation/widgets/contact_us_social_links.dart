import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';

class ContactUsSocialLinks extends StatelessWidget {
  const ContactUsSocialLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          tr('or_contact_via'),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.greyText,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(
              icon: Icons.facebook,
              color: const Color(0xFF1877F2),
              onTap: () => _launchURL('https://facebook.com'),
            ),
            SizedBox(width: 20.w),
            _buildSocialIcon(
              icon: Icons.camera_alt_outlined,
              color: const Color(0xFFE4405F),
              onTap: () => _launchURL('https://instagram.com'),
            ),
            SizedBox(width: 20.w),
            _buildSocialIcon(
              icon: Icons.telegram,
              color: const Color(0xFF0088CC),
              onTap: () => _launchURL('https://telegram.org'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 28.w),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
