import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feedback/app_empty_state.dart';
import '../../../../core/widgets/feedback/app_error_state.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../cubit/app_info_cubit.dart';
import '../cubit/app_info_state.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: tr('faqs')),
      body: BlocBuilder<AppInfoCubit, AppInfoState>(
        builder: (context, state) {
          if (state is AppInfoLoading) {
            return const AppLoadingIndicator();
          } else if (state is FaqLoaded) {
            if (state.faqs.isEmpty) {
              return AppEmptyState(title: tr('no_faqs_found'));
            }
            return ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
              itemCount: state.faqs.length,
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                final faq = state.faqs[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.greyText.withValues(alpha: 0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      title: Text(
                        faq.question,
                        style: GoogleFonts.rubik(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF010B38),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                          child: Text(
                            faq.answer,
                            style: GoogleFonts.rubik(
                              fontSize: 14.sp,
                              color: const Color(
                                0xFF010B38,
                              ).withValues(alpha: 0.7),
                              fontWeight: FontWeight.w400,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AppInfoError) {
            return AppErrorState(
              message: state.message,
              onRetry: () => context.read<AppInfoCubit>().getFaqs(),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
