import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/theme/app_text_styles.dart';
import 'package:beyou3/features/ads/domain/entities/ad_details_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AdDetailsBottomActions extends StatelessWidget {
  final AdDetailsEntity ad;

  const AdDetailsBottomActions({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 12.h,
        bottom: MediaQuery.of(context).padding.bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Row(
        children: [
          if (ad.user?.phone != null) ...[
            Expanded(
              child: _buildActionButton(
                label: tr('whatsapp'),
                icon: Icons.chat_bubble_outline,
                color: const Color(0xFF25D366),
                onTap: () =>
                    _launchUrl(context, 'https://wa.me/${ad.user!.phone}'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionButton(
                label: tr('call'),
                icon: Icons.phone_outlined,
                color: AppColors.primary,
                onTap: () => _launchUrl(context, 'tel:${ad.user!.phone}'),
              ),
            ),
          ] else ...[
            Expanded(
              child: _buildActionButton(
                label: tr('contact_seller'),
                icon: Icons.chat_bubble_outline,
                color: AppColors.primary,
                onTap: () {},
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20.w),
      label: Text(label, style: AppTextStyles.font16WhiteSemiBold),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(vertical: 14.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        elevation: 0,
      ),
    );
  }

  Future<void> _launchUrl(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    final LaunchMode mode = urlString.startsWith('http')
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;

    try {
      if (!await launchUrl(url, mode: mode)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(tr('error_occurred'))));
      }
    }
  }
}
