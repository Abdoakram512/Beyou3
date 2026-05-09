import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/widgets/feedback/app_error_state.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../cubit/app_info_cubit.dart';
import '../cubit/app_info_state.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: tr('about_us')),
      floatingActionButton: GestureDetector(
        onTap: _launchWhatsApp,
        child: SvgPicture.asset(AppIcons.whatsapp, width: 60.w, height: 60.w),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: BlocBuilder<AppInfoCubit, AppInfoState>(
        builder: (context, state) {
          if (state is AppInfoLoading) {
            return const AppLoadingIndicator();
          } else if (state is AppInfoError) {
            return AppErrorState(
              message: state.message,
              onRetry: () => context.read<AppInfoCubit>().getAboutUs(),
            );
          } else if (state is AppInfoLoaded) {
            final data = state.data;
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(
                    child: CachedNetworkImage(
                      imageUrl: data.image,
                      height: 120.h,
                      placeholder: (context, url) =>
                          const AppLoadingIndicator(size: 30),
                      errorWidget: (context, url, error) => Icon(
                        Icons.error_outline,
                        size: 50.h,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: Text(
                      data.title,
                      style: GoogleFonts.rubik(
                        fontSize: 18.sp,
                        color: const Color(0xFF010B38),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: const Color(0xFFD2D6DB).withValues(alpha: 0.61),
                    thickness: 1.5,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    data.description,
                    style: GoogleFonts.rubik(
                      fontSize: 15.sp,
                      color: const Color(0xFF010B38).withValues(alpha: 0.7),
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _launchWhatsApp() async {
    const phone = "+201234567890"; // Sample phone
    final url = Uri.parse("https://wa.me/$phone");
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      debugPrint('Error launching WhatsApp: $e');
    }
  }
}
