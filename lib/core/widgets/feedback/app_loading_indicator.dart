import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double? size;

  const AppLoadingIndicator({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size?.w ?? 0.3.sw,
        height: size?.w ?? 0.3.sw,
        child: Lottie.asset(
          'assets/animations/loading.json',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
