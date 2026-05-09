import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class MainNavItem extends StatelessWidget {
  final int index;
  final String iconPath;
  final String labelKey;
  final bool isSelected;
  final VoidCallback onTap;

  const MainNavItem({
    super.key,
    required this.index,
    required this.iconPath,
    required this.labelKey,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _AnimatedNavItem(iconPath: iconPath, isSelected: isSelected),
            SizedBox(height: 4.h),
            Text(
              tr(labelKey),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: isSelected
                    ? const Color(0xFFFF9800)
                    : const Color(0xFF0D0D0D),
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedNavItem extends StatelessWidget {
  final String iconPath;
  final bool isSelected;

  const _AnimatedNavItem({required this.iconPath, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutBack,
      offset: isSelected ? const Offset(0, -0.15) : Offset.zero,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        scale: isSelected ? 1.1 : 1.0,
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? AppColors.primary : Colors.transparent,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      blurRadius: 15.w,
                      spreadRadius: 2.w,
                      offset: Offset(0, 4.h),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: SvgPicture.asset(
              iconPath,
              width: 20.w,
              height: 20.w,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.white : const Color(0xFF0D0D0D),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
