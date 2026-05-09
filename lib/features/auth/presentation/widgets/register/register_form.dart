import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/common/app_text_button.dart';
import '../../../../../../core/widgets/feedback/app_snack_bar.dart';
import '../../cubit/register/register_cubit.dart';
import '../../cubit/register/register_state.dart';
import 'register_form_inputs.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;
  late final GlobalKey<FormState> formKey;

  final FocusNode phoneFocusNode = FocusNode();
  String fullPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneFocusNode.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (formKey.currentState!.validate()) {
      final phone = fullPhoneNumber.isNotEmpty
          ? fullPhoneNumber
          : phoneController.text.trim();

      context.read<RegisterCubit>().register(
        name: nameController.text.trim(),
        phone: phone,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          // ✅ Fix 3.7: Use AppSnackBar for consistent feedback
          AppSnackBar.showSuccess(context, state.message);
          context.push(
            '/otp',
            extra: {
              'phone': fullPhoneNumber.isNotEmpty
                  ? fullPhoneNumber
                  : phoneController.text.trim(),
              'isForgotPassword': false,
            },
          );
        } else if (state is RegisterUnverified) {
          context.push(
            '/otp',
            extra: {'phone': state.phone, 'isForgotPassword': false},
          );
        } else if (state is RegisterFailure) {
          AppSnackBar.showError(context, state.message);
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            RegisterFormInputs(
              nameController: nameController,
              phoneController: phoneController,
              passwordController: passwordController,
              confirmPasswordController: confirmPasswordController,
              phoneFocusNode: phoneFocusNode,
              onPhoneChanged: (phone) => fullPhoneNumber = phone,
            ),
            SizedBox(height: 32.h),
            BlocBuilder<RegisterCubit, RegisterState>(
              builder: (context, state) {
                return AppTextButton(
                  buttonText: tr('create_account'),
                  textStyle: AppTextStyles.font18WhiteSemiBold,
                  isLoading: state is RegisterLoading,
                  onPressed: _handleRegister,
                  backgroundColor: AppColors.primary,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
