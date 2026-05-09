import 'package:beyou3/core/helpers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/helpers/app_validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/app_text_button.dart';
import '../../../../core/widgets/common/app_text_form_field.dart';
import '../../../../core/widgets/form/app_phone_field.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../../../core/helpers/secure_storage_helper.dart';
import '../../../../core/config/dependency_injection/di.dart';
import '../cubit/login/login_cubit.dart';
import '../cubit/login/login_state.dart';

class LoginScreen extends StatefulWidget {
  final Map<String, dynamic>? extra;
  const LoginScreen({super.key, this.extra});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final GlobalKey<FormState> formKey;

  bool isPasswordObscured = true;
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

  void _loadRememberedData() async {
    final savedRememberMe = SharedPrefHelper.getData(key: 'remember_me');
    if (savedRememberMe is bool) {
      rememberMe = savedRememberMe;
    }
    if (rememberMe) {
      // ✅ Fix 1.4: Read phone from SecureStorage (encrypted) instead of SharedPrefs
      final savedPhone = await getIt<SecureStorageHelper>().readData(
        key: 'saved_phone',
      );
      if (savedPhone != null && savedPhone.isNotEmpty) {
        phoneController.text = savedPhone;
      }
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) async {
          if (state is LoginSuccess) {
            // Save remember me preference
            await SharedPrefHelper.saveData(
              key: 'remember_me',
              value: rememberMe,
            );
            if (rememberMe) {
              // ✅ Fix 1.4: Save phone in SecureStorage (encrypted) instead of SharedPrefs
              await getIt<SecureStorageHelper>().writeData(
                key: 'saved_phone',
                value: phoneController.text,
              );
            } else {
              await getIt<SecureStorageHelper>().deleteData(key: 'saved_phone');
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
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 44.h),
                  // Welcome Title
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF202954).withValues(alpha: 0.40),
                        const Color(0xFF202954).withValues(alpha: 0.74),
                        const Color(0xFF202954),
                      ],
                    ).createShader(bounds),
                    child: Text(
                      'welcome'.tr(),
                      style: AppTextStyles.font36AuthTitle,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  // Subtitle
                  Text(
                    'welcome_subtitle'.tr(),
                    style: AppTextStyles.font14AuthSubtitle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  // Login Section Title
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      'login'.tr(),
                      style: AppTextStyles.font20AuthSectionTitle,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Phone Number Field
                  AppPhoneField(
                    controller: phoneController,
                    labelText: 'phone_number'.tr(),
                    hintText: 'enter_phone_number'.tr(),
                    onChanged: (phone) {
                      fullPhoneNumber = phone.completeNumber;
                    },
                  ),
                  SizedBox(height: 20.h),
                  // Password Field
                  AppTextFormField(
                    controller: passwordController,
                    labelText: 'password'.tr(),
                    hintText: '****',
                    isObscureText: isPasswordObscured,
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: AppColors.grey,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordObscured = !isPasswordObscured;
                        });
                      },
                      icon: Icon(
                        isPasswordObscured
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.grey,
                      ),
                    ),
                    validator: AppValidators.validateLoginPassword,
                  ),
                  SizedBox(height: 16.h),
                  // Action Row (Remember Me & Forgot Password)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 24.h,
                                width: 24.w,
                                child: Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                  activeColor: AppColors.primary,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side: const BorderSide(
                                    color: Color(0xFF6C7278),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Flexible(
                                child: Text(
                                  'remember_me'.tr(),
                                  style: AppTextStyles.font16RememberMe,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Flexible(
                          child: SizedBox(
                            height: 24.h,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () => context.push('/forgot-password'),
                              child: Text(
                                'forgot_password_question'.tr(),
                                style: AppTextStyles.font14OrangeRegular,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Login Button
                  AppTextButton(
                    buttonText: 'login'.tr(),
                    textStyle: AppTextStyles.font18WhiteSemiBold,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<LoginCubit>().login(
                          phone: fullPhoneNumber.isNotEmpty
                              ? fullPhoneNumber
                              : phoneController.text.trim(),
                          password: passwordController.text,
                        );
                      }
                    },
                    backgroundColor: AppColors.primary,
                    isLoading: state is LoginLoading,
                  ),
                  SizedBox(height: 16.h),
                  // Guest Login Button
                  AppTextButton(
                    buttonText: 'guest_login'.tr(),
                    textStyle: AppTextStyles.font18GreenSemiBold,
                    onPressed: () {
                      AuthHelper.logout();
                      context.go('/home');
                    },
                    backgroundColor: AppColors.white,
                    borderSide: const BorderSide(
                      color: AppColors.secondaryGreen,
                      width: 1,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  // Footer (Don't have account?)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'dont_have_account'.tr(),
                        style: AppTextStyles.font14GreyRegular,
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: Text(
                          'create_new_account'.tr(),
                          style: AppTextStyles.font14OrangeRegular.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
