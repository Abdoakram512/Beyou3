// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';

// class SocialLoginButton extends StatelessWidget {
//   final Widget icon;
//   final String text;
//   final VoidCallback onPressed;

//   const SocialLoginButton({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPressed,
//       child: Container(
//         width: double.infinity,
//         height: 54.h,
//         decoration: BoxDecoration(
//           color: AppColors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(
//             color: const Color(0xFFE8ECF4), // Light blue-grey border from screenshot
//             width: 1,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             icon,
//             SizedBox(width: 8.w),
//             Text(
//               text,
//               style: AppTextStyles.font16BlackMedium,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
