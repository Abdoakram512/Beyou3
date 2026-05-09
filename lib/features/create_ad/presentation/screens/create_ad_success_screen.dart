// ============================================================
// create_ad_success_screen.dart
// ============================================================

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../widgets/success_hero_section.dart';
import '../widgets/ad_status_card.dart';
import '../widgets/success_primary_button.dart';

// =============================================================
// ENTRY POINT
// =============================================================

class CreateAdSuccessScreen extends StatefulWidget {
  const CreateAdSuccessScreen({super.key});

  @override
  State<CreateAdSuccessScreen> createState() => _CreateAdSuccessScreenState();
}

class _CreateAdSuccessScreenState extends State<CreateAdSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ─── Hero ───
              const SuccessHeroSection(),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),

                    // ─── Status Card ───
                    const AdStatusCard(),

                    SizedBox(height: 20.h),

                    // ─── Buttons ───
                    SizedBox(
                      width: double.infinity,
                      child: SuccessPrimaryButton(
                        label: tr('home_page'),
                        icon: Icons.home_rounded,
                        onTap: () => context.go('/home'),
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
