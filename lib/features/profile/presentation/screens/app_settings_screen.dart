import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/feedback/app_snack_bar.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/profile_menu_item.dart';
import '../../../../core/widgets/dialogs/delete_account_confirm_dialog.dart';
import '../../../../core/widgets/dialogs/login_requirement_dialog.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: tr('app_settings')),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          final s = state;
          if (s is ProfileDeleteAccountSuccess) {
            // ✅ Fix 3.7: AppSnackBar for consistent feedback
            AppSnackBar.showSuccess(
              context,
              "account_deleted_successfully".tr(),
            );
            context.go('/login');
          } else if (s is ProfileError) {
            AppSnackBar.showError(context, s.message);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 16.h),

              ProfileMenuItem(
                icon: Icons.security_outlined,
                title: "privacy_policy".tr(),
                onTap: () => context.push('/privacy-policy'),
              ),
              ProfileMenuItem(
                icon: Icons.article_outlined,
                title: "terms_and_conditions".tr(),
                onTap: () => context.push('/terms'),
              ),
              ProfileMenuItem(
                icon: Icons.share_outlined,
                title: "share_app".tr(),
                onTap: () => Share.share("check_out_the_app".tr()),
              ),
              ProfileMenuItem(
                icon: Icons.grade_outlined,
                title: "rate_app".tr(),
                onTap: () => _launchStoreRating(),
              ),
              SizedBox(height: 24.h),
              _buildDeleteAccountButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListTile(
        onTap: () => _showDeleteAccountDialog(context),
        leading: Icon(Icons.delete_outline, color: AppColors.error, size: 24.w),
        title: Text(
          "delete_account".tr(),
          style: TextStyle(
            fontSize: 16.sp,
            color: AppColors.error,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    final state = context.read<ProfileCubit>().state;
    if (state is ProfileGuest) {
      LoginRequirementDialog.show(context);
      return;
    }

    DeleteAccountConfirmDialog.show(
      context,
      onDelete: () => context.read<ProfileCubit>().deleteAccount(),
    );
  }

  Future<void> _launchStoreRating() async {
    final Uri url = Uri.parse(
      'https://play.google.com/store/apps/details?id=tech.brmja.beyou3',
    ); // Replace with actual app ID
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(
          Uri.parse(
            'https://play.google.com/store/apps/details?id=tech.brmja.beyou3',
          ),
          mode: LaunchMode.externalApplication,
        );
      }
    } catch (e) {
      debugPrint('Error launching store: $e');
    }
  }
}
