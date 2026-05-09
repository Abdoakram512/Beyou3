import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/config/dependency_injection/di.dart';
import '../../../../core/helpers/auth_helper.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dialogs/login_requirement_dialog.dart';
import '../../../ads/presentation/screens/my_ads_screen.dart';
import '../../../categories/presentation/screens/categories_screen.dart';
import '../../../create_ad/presentation/screens/create_ad_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../profile/presentation/cubit/profile_cubit.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import '../../../auth/presentation/cubit/auth_status/auth_status_cubit.dart';
import '../../../auth/presentation/cubit/auth_status/auth_status_state.dart';
import '../widgets/main_bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  /// Global key to access MainScreen's state for tab switching.
  static final GlobalKey<MainScreenState> mainKey =
      GlobalKey<MainScreenState>();

  /// Switch to a specific tab from anywhere (e.g., child screens).
  static void switchToTab(int index) {
    mainKey.currentState?._onItemTapped(index);
  }

  MainScreen() : super(key: mainKey);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) async {
    if (index == 2 || index == 3) {
      if (await AuthHelper.isGuest()) {
        if (mounted) {
          LoginRequirementDialog.show(
            context,
            redirectPath: index == 2 ? '/create-ad' : '/my-ads',
          );
        }
        return;
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const CategoriesScreen(),
      const CreateAdScreen(),
      const MyAdsScreen(),
      BlocProvider(
        key: const ValueKey(
          'profile_tab',
        ), // Force rebuild of provider on locale change
        create: (context) => getIt<ProfileCubit>(),
        child: const ProfileScreen(),
      ),
    ];

    return Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: BlocListener<AuthStatusCubit, AuthStatusState>(
        listener: (context, state) {
          if (state is AuthStatusAuthenticated) {
            // When user logs in, ensure all tabs refresh their data
            // ProfileCubit is inside the IndexedStack, we can find it via the context
            // but since it's lazy, we might need a better way.
            // Actually, we can just trigger a global event or refresh the main key.
            setState(() {
              // Re-creating the pages list will refresh the BlocProviders
            });
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: IndexedStack(
            key: ValueKey(
              'main_stack_${context.read<AuthStatusCubit>().state is AuthStatusAuthenticated}',
            ),
            index: _selectedIndex,
            children: pages,
          ),
          bottomNavigationBar: MainBottomNavigationBar(
            selectedIndex: _selectedIndex,
            onItemSelected: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
