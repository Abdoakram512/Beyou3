import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileMenuItem extends StatelessWidget {
  final String? svgIcon;
  final IconData? icon;
  final String title;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? iconColor;
  final Color? textColor;
  final bool showDivider;

  const ProfileMenuItem({
    super.key,
    this.svgIcon,
    this.icon,
    required this.title,
    this.onTap,
    this.trailing,
    this.iconColor,
    this.textColor,
    this.showDivider = true,
  }) : assert(svgIcon != null || icon != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
          leading: svgIcon != null
              ? SvgPicture.asset(
                  svgIcon!,
                  width: 20.w,
                  height: 20.w,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? AppColors.profileGrey,
                    BlendMode.srcIn,
                  ),
                )
              : Icon(
                  icon!,
                  color: iconColor ?? AppColors.profileGrey,
                  size: 20.w,
                ),
          title: Text(
            title,
            style: textColor != null
                ? AppTextStyles.font16ProfileGreyMedium.copyWith(
                    color: textColor,
                  )
                : AppTextStyles.font16ProfileGreyMedium,
          ),
          trailing:
              trailing ??
              Icon(
                Icons.arrow_forward_ios,
                size: 16.w,
                color: AppColors.greyText,
              ),
          onTap: onTap,
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Divider(
              height: 1,
              color: AppColors.greyText.withValues(alpha: 0.2),
            ),
          ),
      ],
    );
  }
}
