import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdDetailsDivider extends StatelessWidget {
  const AdDetailsDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Divider(
        height: 0.5.h,
        thickness: 0.5,
        color: Colors.grey.withValues(alpha: 0.15),
      ),
    );
  }
}
