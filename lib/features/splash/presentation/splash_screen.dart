import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/helpers/shared_pref_helper.dart';
import '../../../core/helpers/auth_helper.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_images.dart';
import 'widgets/language_bottom_sheet.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  void _startSplash() async {
    final hasSeenSplash =
        SharedPrefHelper.getData(key: 'has_seen_splash') ?? false;

    // Always wait 3 seconds to show the splash logo
    await Future.delayed(const Duration(seconds: 3));

    if (!hasSeenSplash) {
      await SharedPrefHelper.saveData(key: 'has_seen_splash', value: true);
    }

    if (!mounted) return;
    _startNavigation();
  }

  void _startNavigation() async {
    final isFirstTime = SharedPrefHelper.getData(key: 'is_first_time') ?? true;

    if (isFirstTime) {
      LanguageBottomSheet.show(context);
    } else {
      final rememberMe = SharedPrefHelper.getData(key: 'remember_me') ?? false;
      final loggedIn = await AuthHelper.isLoggedIn();

      if (!mounted) return;

      if (loggedIn && rememberMe) {
        context.replace('/home');
      } else {
        // If not remembered, clear token to ensure fresh login
        if (loggedIn && !rememberMe) {
          await AuthHelper.logout();
        }
        context.replace('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Image.asset(AppImages.splashGif, fit: BoxFit.contain),
      ),
    );
  }
}
