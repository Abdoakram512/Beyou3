import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/helpers/app_validators.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';
import '../../../../../../core/widgets/common/app_text_button.dart';
import '../../../../../../core/widgets/form/app_phone_field.dart';
import '../../../../../../core/helpers/shared_pref_helper.dart';
import '../../cubit/login/login_cubit.dart';
import '../../cubit/login/login_state.dart';
import '../auth_password_field.dart';
import 'login_options_row.dart';

class LoginForm extends StatefulWidget {
  final Map<String, dynamic>? extra;
  const LoginForm({super.key, this.extra});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> formKey;

  bool rememberMe = false;
  String fullPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    formKey = GlobalKey<FormState>();
    _loadRememberedData();
  }

  void _loadRememberedData() {
    final savedPhone = SharedPrefHelper.getData(key: 'saved_phone');
    final savedRememberMe = SharedPrefHelper.getData(key: 'remember_me');
    if (savedRememberMe is bool) {
      rememberMe = savedRememberMe;
    }
    if (rememberMe && savedPhone is String) {
      phoneController.text = savedPhone;
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
        phone: fullPhoneNumber.isNotEmpty
            ? fullPhoneNumber
            : phoneController.text.trim(),
        password: passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) async {
        if (state is LoginSuccess) {
          await SharedPrefHelper.saveData(
            key: 'remember_me',
            value: rememberMe,
          );
          if (rememberMe) {
            await SharedPrefHelper.saveData(
              key: 'saved_phone',
              value: phoneController.text,
            );
          } else {
            await SharedPrefHelper.removeData(key: 'saved_phone');
          }

          final redirectPath = widget.extra?['redirectPath'];
          if (redirectPath != null) {
            if (mounted) context.go(redirectPath);
          } else {
            if (mounted) context.go('/home');
          }
        } else if (state is LoginUnverified) {
          context.push(
            '/otp',
            extra: {'phone': state.phone, 'isForgotPassword': false},
          );
        } else if (state is LoginFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                'login'.tr(),
                style: AppTextStyles.font20AuthSectionTitle,
              ),
            ),
            SizedBox(height: 24.h),
            AppPhoneField(
              controller: phoneController,
              labelText: 'phone_number'.tr(),
              hintText: 'enter_phone_number'.tr(),
              onChanged: (phone) {
                final number = phone.number.startsWith('0')
                    ? phone.number.substring(1)
                    : phone.number;
                fullPhoneNumber = '+${phone.countryCode}$number';
              },
            ),
            SizedBox(height: 20.h),
            AuthPasswordField(
              controller: passwordController,
              labelText: 'password'.tr(),
              hintText: '****',
              validator: AppValidators.validateLoginPassword,
            ),
            SizedBox(height: 16.h),
            LoginOptionsRow(
              rememberMe: rememberMe,
              onRememberMeChanged: (val) {
                setState(() {
                  rememberMe = val ?? false;
                });
              },
            ),
            SizedBox(height: 24.h),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return AppTextButton(
                  buttonText: 'login'.tr(),
                  textStyle: AppTextStyles.font18WhiteSemiBold,
                  onPressed: _handleLogin,
                  backgroundColor: AppColors.primary,
                  isLoading: state is LoginLoading,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
