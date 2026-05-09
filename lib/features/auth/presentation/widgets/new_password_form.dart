import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/helpers/app_validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/app_text_button.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import '../cubit/reset_password/reset_password_cubit.dart';
import '../cubit/reset_password/reset_password_state.dart';
import 'password_validator_widget.dart';

class NewPasswordForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final String phone;
  final ResetPasswordState state;

  const NewPasswordForm({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phone,
    required this.state,
  });

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Password Field
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              tr('new_password_label'),
              style: AppTextStyles.font16OrangeMedium,
            ),
          ),
          SizedBox(height: 12.h),
          AppTextFormField(
            controller: widget.passwordController,
            hintText: "****",
            isObscureText: isPasswordObscured,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.grey,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(
                () => isPasswordObscured = !isPasswordObscured,
              ),
              icon: Icon(
                isPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey,
              ),
            ),
            validator: AppValidators.validatePassword,
          ),
          PasswordValidatorWidget(controller: widget.passwordController),
          SizedBox(height: 24.h),

          // Confirm Password Field
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              tr('confirm_new_password_label'),
              style: AppTextStyles.font16OrangeMedium,
            ),
          ),
          SizedBox(height: 12.h),
          AppTextFormField(
            controller: widget.confirmPasswordController,
            hintText: tr('confirm_new_password_label'),
            isObscureText: isConfirmPasswordObscured,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.grey,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(
                () => isConfirmPasswordObscured = !isConfirmPasswordObscured,
              ),
              icon: Icon(
                isConfirmPasswordObscured
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.grey,
              ),
            ),
            validator: (val) => AppValidators.validateConfirmationPassword(
              val,
              widget.passwordController.text,
            ),
          ),
          SizedBox(height: 40.h),

          // Reset Button
          AppTextButton(
            buttonText: tr('reset_password_button'),
            textStyle: AppTextStyles.font18WhiteSemiBold,
            isLoading: widget.state is ResetPasswordLoading,
            onPressed: () {
              if (widget.formKey.currentState!.validate()) {
                context.read<ResetPasswordCubit>().resetPassword(
                      phone: widget.phone,
                      password: widget.passwordController.text,
                      passwordConfirmation: widget.confirmPasswordController.text,
                    );
              }
            },
            backgroundColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
