import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// =============================================================
// AD STATUS CARD
// =============================================================

class AdStatusCard extends StatelessWidget {
  const AdStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              tr('ad_status_title'),
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888780),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Step 1 — done
          _AdStep(
            dotChild: Icon(
              Icons.check,
              size: 16.w,
              color: const Color(0xFFFB8C00),
            ),
            dotColor: const Color(0xFFFB8C00).withValues(alpha: 0.12),
            lineColor: const Color(0xFFFB8C00).withValues(alpha: 0.12),
            title: tr('ad_uploaded_title'),
            subtitle: tr('ad_received_successfully'),
            isLast: false,
          ),

          // Step 2 — in progress
          _AdStep(
            dotChild: Text('⏳', style: TextStyle(fontSize: 14.sp)),
            dotColor: const Color(0xFFFEF3C7),
            lineColor: const Color(0xFFFEF3C7),
            title: tr('pending_review'),
            subtitle: tr('team_reviewing_now'),
            isLast: false,
          ),

          // Step 3 — pending
          _AdStep(
            dotChild: Container(
              width: 12.w,
              height: 12.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF888780), width: 1.5),
              ),
            ),
            dotColor: const Color(0xFFF1EFE8),
            lineColor: Colors.transparent,
            title: tr('publish_and_activate'),
            subtitle: tr('show_to_buyers_note'),
            isLast: true,
          ),
        ],
      ),
    );
  }
}

// ─── Single step row ───

class _AdStep extends StatelessWidget {
  final Widget dotChild;
  final Color dotColor;
  final Color lineColor;
  final String title;
  final String subtitle;
  final bool isLast;

  const _AdStep({
    required this.dotChild,
    required this.dotColor,
    required this.lineColor,
    required this.title,
    required this.subtitle,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // dot + connector line
        Column(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
              child: Center(child: dotChild),
            ),
            if (!isLast)
              Container(width: 1.5.w, height: 28.h, color: lineColor),
          ],
        ),
        SizedBox(width: 14.w),
        Padding(
          padding: EdgeInsets.only(top: 6.h, bottom: isLast ? 0 : 4.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2C2C2A),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF888780),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
