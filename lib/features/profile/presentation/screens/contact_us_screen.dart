import 'package:beyou3/core/config/dependency_injection/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/feedback/app_snack_bar.dart';
import '../cubit/contact_us_cubit.dart';
import '../widgets/contact_us_message_form.dart';
import '../widgets/contact_us_social_links.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ContactUsCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: tr('contact_us')),
        body: BlocListener<ContactUsCubit, ContactUsState>(
          listener: (context, state) {
            if (state is ContactUsSuccess) {
              // ✅ Fix 3.7: AppSnackBar for consistent success feedback
              AppSnackBar.showSuccess(context, state.message.tr());
              context.pop();
            } else if (state is ContactUsError) {
              AppSnackBar.showError(context, state.message);
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 32.h),
                const ContactUsMessageForm(),
                SizedBox(height: 48.h),
                const ContactUsSocialLinks(),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "get_in_touch".tr(),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.authTitleColor,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "we_are_here_to_help".tr(),
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.greyText,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
