import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/theme/app_text_styles.dart';

/// A premium empty state widget used across the app.
///
/// Displays a contained card with illustration, title, subtitle,
/// and an optional call-to-action button.
class AppEmptyState extends StatefulWidget {
  final String? title;
  final String? subtitle;
  final IconData? icon;
  final double? lottieSize;
  final VoidCallback? onActionPressed;
  final String? actionLabel;
  final String? lottieAsset;

  const AppEmptyState({
    super.key,
    this.title,
    this.subtitle,
    this.icon,
    this.lottieSize,
    this.onActionPressed,
    this.actionLabel,
    this.lottieAsset,
  });

  @override
  State<AppEmptyState> createState() => _AppEmptyStateState();
}

class _AppEmptyStateState extends State<AppEmptyState>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _fadeIn,
        child: SlideTransition(
          position: _slideUp,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: AppColors.borderGrey.withValues(alpha: 0.6),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Illustration Area ─────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 24.h),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20.r),
                      ),
                    ),
                    child: _buildIllustration(),
                  ),

                  // ── Content Area ──────────────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 28.h),
                    child: Column(
                      children: [
                        // Title
                        Text(
                          widget.title ?? tr('no_ads_found'),
                          style: AppTextStyles.font18BlackSemiBold,
                          textAlign: TextAlign.center,
                        ),

                        // Subtitle
                        if (widget.subtitle != null) ...[
                          SizedBox(height: 8.h),
                          Text(
                            widget.subtitle!,
                            style: AppTextStyles.font14GreyRegular.copyWith(
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],

                        // CTA Button
                        if (widget.onActionPressed != null &&
                            widget.actionLabel != null) ...[
                          SizedBox(height: 24.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: widget.onActionPressed,
                              icon: Icon(Icons.add_rounded, size: 20.sp),
                              label: Text(
                                widget.actionLabel!,
                                style: AppTextStyles.font14WhiteSemiBold,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    final double size = widget.lottieSize ?? 150.w;

    if (widget.lottieAsset != null) {
      return Lottie.asset(
        widget.lottieAsset!,
        width: size,
        height: size,
        fit: BoxFit.contain,
      );
    }

    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary.withValues(alpha: 0.1),
      ),
      child: Icon(
        widget.icon ?? Icons.inbox_rounded,
        size: 40.sp,
        color: AppColors.primary,
      ),
    );
  }
}
