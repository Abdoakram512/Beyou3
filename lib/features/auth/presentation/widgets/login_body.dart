import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'login/login_header.dart';
import 'login/login_form.dart';
import 'login/login_footer.dart';

class LoginBody extends StatelessWidget {
  final Map<String, dynamic>? extra;
  const LoginBody({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 44.h),
          const LoginHeader(),
          SizedBox(height: 24.h),
          LoginForm(extra: extra),
          SizedBox(height: 16.h),
          const LoginFooter(),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
