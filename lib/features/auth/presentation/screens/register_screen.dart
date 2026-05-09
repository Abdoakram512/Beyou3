import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/register_body.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: RegisterBody(),
      ),
    );
  }
}
