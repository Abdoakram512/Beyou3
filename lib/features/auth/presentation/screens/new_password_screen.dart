import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/reset_password/reset_password_cubit.dart';
import '../cubit/reset_password/reset_password_state.dart';

import 'package:easy_localization/easy_localization.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/feedback/app_snack_bar.dart';
import '../widgets/new_password_form.dart';

class NewPasswordScreen extends StatefulWidget {
  final String phone;
  final String otp;
  const NewPasswordScreen({super.key, required this.phone, required this.otp});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: tr('new_password_title')),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
          listener: (context, state) {
            if (state is ResetPasswordSuccess) {
              context.pushReplacement('/reset-success');
            } else if (state is ResetPasswordFailure) {
              // ✅ Fix 3.7: AppSnackBar for consistent error feedback
              AppSnackBar.showError(context, state.message);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  NewPasswordForm(
                    formKey: _formKey,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    phone: widget.phone,
                    state: state,
                  ),
                  SizedBox(height: 48.h),
                ],
              ),
            );
          },
        ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
