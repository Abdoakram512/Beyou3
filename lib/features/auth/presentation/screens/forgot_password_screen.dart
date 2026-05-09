import 'package:beyou3/core/helpers/app_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/app_text_button.dart';
import '../../../../core/widgets/form/app_phone_field.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../cubit/forgot_password/forgot_password_cubit.dart';
import '../cubit/forgot_password/forgot_password_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final TextEditingController phoneController;
  late final GlobalKey<FormState> formKey;
  String fullPhoneNumber = '';

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: tr('forgot_password_title')),
      body: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordSuccess) {
            context.push(
              '/otp',
              extra: {
                'phone': fullPhoneNumber.isNotEmpty
                    ? fullPhoneNumber
                    : phoneController.text.trim(),
                'isForgotPassword': true,
              },
            );
          } else if (state is ForgotPasswordFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          // ✅ Fix 3.2: Use LayoutBuilder + ConstrainedBox so the button
          // stays near the bottom dynamically instead of a hardcoded SizedBox
          return LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20.h),

                          // Subtitles
                          Text(
                            tr('forgot_password_subtitle1'),
                            style: AppTextStyles.font16GreyRegular.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textDark,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            tr('forgot_password_subtitle2'),
                            style: AppTextStyles.font14GreyRegular,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 48.h),
                          // Field Label
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              tr('phone_number'),
                              style: AppTextStyles.font16BlackMedium,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Phone Number Field
                          AppPhoneField(
                            controller: phoneController,
                            hintText: tr('enter_phone_number'),
                            validator: (phone) {
                              if (phone == null || phone.number.isEmpty) {
                                return tr('required');
                              }
                              return null;
                            },
                            onChanged: (phone) {
                              final engNumber =
                                  AppValidators.convertArabicToEnglishNumbers(
                                    phone.number,
                                  );
                              final number = engNumber.startsWith('0')
                                  ? engNumber.substring(1)
                                  : engNumber;
                              fullPhoneNumber =
                                  '+${phone.countryCode.replaceAll('+', '')}$number';
                            },
                          ),
                          const Spacer(), // Pushes button to bottom dynamically
                          // Send Code Button
                          AppTextButton(
                            buttonText: tr('send_code'),
                            textStyle: AppTextStyles.font18WhiteSemiBold,
                            isLoading: state is ForgotPasswordLoading,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<ForgotPasswordCubit>().resetPassword(
                                  fullPhoneNumber.isNotEmpty
                                      ? fullPhoneNumber
                                      : phoneController.text.trim(),
                                );
                              }
                            },
                            backgroundColor: AppColors.primary,
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
