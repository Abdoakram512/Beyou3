import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'register/register_header.dart';
import 'register/register_form.dart';
import 'register/register_footer.dart';

class RegisterBody extends StatelessWidget {
  const RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          const RegisterHeader(),
          SizedBox(height: 32.h),
          const RegisterForm(),
          SizedBox(height: 24.h),
          const RegisterFooter(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
