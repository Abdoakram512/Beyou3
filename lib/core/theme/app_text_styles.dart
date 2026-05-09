import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle font32BlueGreyBold = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.blueGrey,
  );

  static TextStyle font36AuthTitle = TextStyle(
    fontSize: 36.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.authTitleColor,
  );

  static TextStyle font14AuthSubtitle = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.authSubtitleColor,
  );

  static TextStyle font20AuthSectionTitle = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.authSectionTitleColor,
  );

  static TextStyle font16RememberMe = GoogleFonts.rubik(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: const Color(0xFF8C8C8C),
    height: 1.5,
    letterSpacing: -0.16,
  );

  static TextStyle font16GreyRegular = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.greyText,
  );

  static TextStyle font20BlackBold = TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static TextStyle font16BlackMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static TextStyle font14GreyRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.greyText,
  );

  static TextStyle font14OrangeRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.primary,
  );

  static TextStyle font18WhiteSemiBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle font18GreenSemiBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryGreen,
  );

  static TextStyle font16BlackSemiBold = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static TextStyle font24BlackBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle font18BlackSemiBold = TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle font14BlackRegular = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  static TextStyle font12GreyRegular = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.greyText,
  );

  static TextStyle font14WhiteSemiBold = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle font24OrangeBold = TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  static TextStyle font16OrangeMedium = TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static TextStyle font32BlackBold = TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle font16NavyMedium = GoogleFonts.rubik(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.darkNavy,
  );

  static TextStyle font16ProfileGreyMedium = GoogleFonts.rubik(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.profileGrey,
  );

  static TextStyle font20BrownSemiBold = GoogleFonts.rubik(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.darkBrown,
    letterSpacing: 20.sp * 0.03, // 3% of font size
  );

  static TextStyle font16WhiteMedium = GoogleFonts.rubik(
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static TextStyle font16WhiteSemiBold = GoogleFonts.rubik(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static TextStyle font10WhiteBold = TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
