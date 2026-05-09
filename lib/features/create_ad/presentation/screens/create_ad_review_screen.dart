// import 'dart:io';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_text_styles.dart';
// import '../../../../core/widgets/common/app_text_button.dart';
// import '../cubit/create_ad_cubit.dart';
// import '../cubit/create_ad_state.dart';
// import 'create_ad_success_screen.dart';

// class CreateAdReviewScreen extends StatelessWidget {
//   final String categoryName;
//   final int categoryId;
//   final String? categoryType;
//   final String name;
//   final String description;
//   final String address;
//   final String area;
//   final String? brand;
//   final String purpose;
//   final String price;
//   final File mainImage;
//   final List<File> otherImages;
//   final String? lat;
//   final String? lng;

//   const CreateAdReviewScreen({
//     super.key,
//     required this.categoryName,
//     required this.categoryId,
//     this.categoryType,
//     required this.name,
//     required this.description,
//     required this.address,
//     required this.area,
//     this.brand,
//     required this.purpose,
//     required this.price,
//     required this.mainImage,
//     required this.otherImages,
//     this.lat,
//     this.lng,
//   });

//   String _getPurposeText() {
//     switch (purpose) {
//       case 'sale':
//         return tr('for_sale');
//       case 'rent':
//         return tr('for_rent');
//       default:
//         return purpose;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<CreateAdCubit, CreateAdState>(
//       listener: (context, state) {
//         if (state is CreateAdSuccess) {
//           context.go('/create-ad-success');
//         } else if (state is CreateAdFailure) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(state.message),
//               backgroundColor: AppColors.error,
//             ),
//           );
//         }
//       },
//       builder: (context, state) {
//         return Scaffold(
//           backgroundColor: AppColors.background,
//           appBar: AppBar(
//             backgroundColor: AppColors.background,
//             elevation: 0,
//             centerTitle: true,
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_forward_ios,
//                 color: AppColors.textDark,
//                 size: 20.sp,
//               ),
//               onPressed: () => Navigator.pop(context),
//             ),
//             title: Text(
//               tr('ad_details_title'),
//               style: AppTextStyles.font18BlackSemiBold.copyWith(color: AppColors.textDark),
//             ),
//           ),
//           body: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 SizedBox(height: 16.h),

//                 // Section Title
//                 Center(
//                   child: Text(
//                     tr('ad_data_label'),
//                     style: AppTextStyles.font20BlackBold,
//                   ),
//                 ),
//                 SizedBox(height: 20.h),

//                 // Ad Details
//                 _buildDetailRow(tr('ad_name_review_label'), name),
//                 _buildDivider(),
//                 _buildDetailRow(tr('description_label'), description),
//                 _buildDivider(),
//                 _buildDetailRow(tr('category_label'), categoryName),
//                 _buildDivider(),
//                 // Vehicle-specific
//                 if (brand != null) ...[
//                   _buildDetailRow(tr('brand_label'), brand!),
//                   _buildDivider(),
//                 ],
//                 // Real estate-specific
//                 if (address.isNotEmpty) ...[
//                   _buildDetailRow(tr('address_detail_label'), address),
//                   _buildDivider(),
//                 ],
//                 if (area.isNotEmpty) ...[
//                   _buildDetailRow(
//                     tr('area_detail_label'),
//                     '$area ${tr('meter')}',
//                   ),
//                   _buildDivider(),
//                 ],
//                 // Vehicle & real estate
//                 if (purpose.isNotEmpty) ...[
//                   _buildDetailRow(
//                     tr('purpose_detail_label'),
//                     _getPurposeText(),
//                   ),
//                   _buildDivider(),
//                 ],
//                 _buildDetailRow(tr('price_label'), '$price ${tr('egp')}'),
//                 _buildDivider(),

//                 SizedBox(height: 16.h),

//                 // Images section
//                 Text(
//                   tr('ad_images_review_label'),
//                   style: AppTextStyles.font16BlackMedium,
//                 ),
//                 SizedBox(height: 12.h),
//                 _buildImagesSection(),

//                 SizedBox(height: 32.h),

//                 // Publish button
//                 AppTextButton(
//                   buttonText: tr('publish_ad'),
//                   textStyle: AppTextStyles.font16WhiteSemiBold,
//                   backgroundColor: AppColors.primary,
//                   isLoading: state is CreateAdLoading,
//                   onPressed: () {
//                     context.read<CreateAdCubit>().createAd();
//                   },
//                 ),

//                 SizedBox(height: 40.h),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: AppTextStyles.font14GreyRegular.copyWith(height: 1.5, color: AppColors.authSubtitleColor),
//               textAlign: TextAlign.start,
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Text(
//             '$label :',
//             style: AppTextStyles.font14BlackRegular.copyWith(fontWeight: FontWeight.w600, color: AppColors.textDark),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDivider() {
//     return Divider(color: AppColors.borderGrey, height: 1.h);
//   }

//   Widget _buildImagesSection() {
//     final allImages = [mainImage, ...otherImages];
//     return SizedBox(
//       height: 100.h,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         reverse: true,
//         itemCount: allImages.length,
//         separatorBuilder: (_, _) => SizedBox(width: 10.w),
//         itemBuilder: (context, index) {
//           return ClipRRect(
//             borderRadius: BorderRadius.circular(10.r),
//             child: Image.file(
//               allImages[index],
//               width: 100.w,
//               height: 100.h,
//               fit: BoxFit.cover,
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
