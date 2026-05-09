import 'dart:ui' as ui show TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import '../../../../core/helpers/app_validators.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../cubit/otp/otp_cubit.dart';
import '../cubit/otp/otp_state.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  final bool isForgotPassword;
  const OtpScreen({
    super.key,
    required this.phone,
    required this.isForgotPassword,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late final TextEditingController otpController;
  late final GlobalKey<FormState> formKey;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    formKey = GlobalKey<FormState>();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OtpCubit>();

    // Define the default Pin theme
    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 60.h,
      textStyle: AppTextStyles.font24BlackBold,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1.5),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: tr('enter_code_title')),
      body: BlocConsumer<OtpCubit, OtpState>(
          listener: (context, state) {
            if (state is OtpVerifySuccess) {
              if (widget.isForgotPassword) {
                context.push(
                  '/new-password',
                  extra: {'phone': widget.phone, 'otp': otpController.text},
                );
              } else {
                context.push('/register-success');
              }
            } else if (state is OtpVerifyFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is OtpResendFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is OtpResendSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('otp_resent'.tr())));
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),

                    // Subtitles
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        tr('please_verify_phone'),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.black,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      // ✅ Fix 3.4: Simplified — no more fragile split('{}')
                      child: Text(
                        'code_sent_to'.tr(args: [widget.phone]),
                        style: GoogleFonts.ibmPlexSansArabic(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.greyText,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    SizedBox(height: 48.h),
                    // Pin Input (5 boxes)
                    Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: Pinput(
                        length: 5,
                        controller: otpController,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                        submittedPinTheme: defaultPinTheme.copyWith(
                          decoration: defaultPinTheme.decoration!.copyWith(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: AppValidators.validateOTP,
                        onCompleted: (pin) {
                          if (formKey.currentState!.validate()) {
                            cubit.verifyOtp(phone: widget.phone, otp: pin);
                          }
                        },
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // ✅ Fix 3.3: Merged resend + timer into one BlocBuilder.
                    // Resend button is disabled during countdown.
                    BlocBuilder<OtpCubit, OtpState>(
                      buildWhen: (previous, current) =>
                          current is OtpTimerUpdate ||
                          current is OtpResendSuccess,
                      builder: (context, timerState) {
                        final secondsRemaining = timerState is OtpTimerUpdate
                            ? timerState.secondsRemaining
                            : 0;
                        final canResend = secondsRemaining == 0;
                        final minutes = (secondsRemaining ~/ 60)
                            .toString()
                            .padLeft(2, '0');
                        final seconds = (secondsRemaining % 60)
                            .toString()
                            .padLeft(2, '0');

                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  tr('didnt_receive_code'),
                                  style: AppTextStyles.font14BlackRegular
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                TextButton(
                                  onPressed: canResend
                                      ? () => cubit.resendOtp(widget.phone)
                                      : null,
                                  child: Text(
                                    tr('resend'),
                                    style: AppTextStyles.font14OrangeRegular
                                        .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: canResend
                                          ? AppColors.primary
                                          : AppColors.greyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            // Timer display
                            if (!canResend)
                              Text(
                                '$minutes:$seconds',
                                style: AppTextStyles.font24BlackBold.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    );
  }
}
