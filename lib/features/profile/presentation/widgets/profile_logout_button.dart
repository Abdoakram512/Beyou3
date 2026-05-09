import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/auth_status/auth_status_cubit.dart';

class ProfileLogoutButton extends StatelessWidget {
  final bool isGuest;

  const ProfileLogoutButton({super.key, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: InkWell(
        onTap: () => _handleLogout(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              isGuest ? Icons.login : Icons.logout,
              color: isGuest ? AppColors.primary : AppColors.error,
              size: 24.w,
            ),
            SizedBox(width: 8.w),
            Text(
              isGuest ? "login".tr() : "logout".tr(),
              style: TextStyle(
                fontSize: 16.sp,
                color: isGuest ? AppColors.primary : AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) {
    if (isGuest) {
      context.go('/login');
    } else {
      _showLogoutDialog(context);
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("logout".tr()),
        content: Text("logout_confirmation".tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("cancel".tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthStatusCubit>().loggedOut();
              context.go('/login');
            },
            child: Text(
              "logout".tr(),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
