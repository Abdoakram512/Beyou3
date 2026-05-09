import 'package:beyou3/features/ads/presentation/screens/category_ads_screen.dart';
import 'package:beyou3/features/ads/presentation/screens/ad_details_screen.dart';
import 'package:beyou3/features/ads/presentation/screens/my_ads_screen.dart';

import 'package:beyou3/features/main/presentation/screens/main_screen.dart';
import 'package:beyou3/features/splash/presentation/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../helpers/auth_helper.dart';
import '../../theme/app_colors.dart';

import '../../../features/auth/presentation/cubit/forgot_password/forgot_password_cubit.dart';
import '../../../features/auth/presentation/cubit/login/login_cubit.dart';
import '../../../features/auth/presentation/cubit/otp/otp_cubit.dart';
import '../../../features/auth/presentation/cubit/register/register_cubit.dart';
import '../../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/new_password_screen.dart';
import '../../../features/auth/presentation/screens/otp_screen.dart';
import '../../../features/auth/presentation/screens/register_screen.dart';
import '../../../features/auth/presentation/screens/register_success_screen.dart';
import '../../../features/auth/presentation/screens/reset_success_screen.dart';
import '../../../features/auth/presentation/cubit/reset_password/reset_password_cubit.dart';
import '../../../features/categories/domain/entities/category_entity.dart';
import '../../../features/categories/presentation/screens/categories_screen.dart';
import '../../../features/categories/presentation/screens/subcategories_screen.dart';
import '../../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../../features/profile/presentation/cubit/personal_data_cubit.dart';
import '../../../features/profile/presentation/cubit/contact_us_cubit.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../features/profile/presentation/screens/personal_data_screen.dart';
import '../../../features/profile/presentation/screens/contact_us_screen.dart';
import '../../../features/profile/presentation/screens/app_settings_screen.dart';
import '../../../features/profile/presentation/screens/terms_screen.dart';
import '../../../features/profile/presentation/screens/about_us_screen.dart';
import '../../../features/profile/presentation/screens/how_we_work_screen.dart';
import '../../../features/profile/presentation/screens/privacy_policy_screen.dart';
import '../../../features/profile/presentation/screens/faqs_screen.dart';
import '../../../features/profile/presentation/cubit/app_info_cubit.dart';
import '../../../features/create_ad/presentation/screens/create_ad_screen.dart';
import '../../../features/create_ad/presentation/screens/create_ad_success_screen.dart';
import '../../../features/edit_ad/presentation/screens/edit_ad_screen.dart';
import '../../../features/edit_ad/presentation/cubit/edit_ad_cubit.dart';
import '../../../features/ads/domain/entities/ad_details_entity.dart';
import '../../../features/create_ad/presentation/cubit/ad_category_selection_cubit.dart';
import '../../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../features/notifications/presentation/screens/notifications_screen.dart';
import '../dependency_injection/di.dart';

class AppRouter {
  static final AppRouter _instance = AppRouter._internal();
  factory AppRouter() => _instance;
  AppRouter._internal();

  // ✅ Fix 2.3: Protected routes that require authentication
  static const _protectedRoutes = [
    '/create-ad',
    '/my-ads',
    '/personal-data',
    '/edit-ad',
    '/notifications',
  ];

  final GoRouter router = GoRouter(
    initialLocation: '/',
    // ✅ Fix 2.3: Auth guard — redirects unauthenticated users to login
    redirect: (context, state) async {
      final isProtected = _protectedRoutes.any(
        (r) => state.matchedLocation.startsWith(r),
      );
      if (isProtected) {
        final isLoggedIn = await AuthHelper.isLoggedIn();
        if (!isLoggedIn) {
          return '/login?redirectPath=${Uri.encodeComponent(state.matchedLocation)}';
        }
      }
      return null;
    },
    // ✅ Fix 2.4: Error page for unknown routes (404)
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded, size: 64.sp, color: Colors.grey),
            SizedBox(height: 16.h),
            Text(
              tr('error_occurred'),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              ),
              child: Text(
                tr('home'),
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    ),
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(path: '/home', builder: (context, state) => MainScreen()),
      GoRoute(
        path: '/login',
        builder: (context, state) {
          // ✅ Fix 2.3: Read redirectPath from query params (set by auth guard)
          final redirectPath = state.uri.queryParameters['redirectPath'];
          final extra = (state.extra as Map<String, dynamic>?) ?? {};
          if (redirectPath != null && !extra.containsKey('redirectPath')) {
            extra['redirectPath'] = Uri.decodeComponent(redirectPath);
          }
          return BlocProvider(
            create: (context) => getIt<LoginCubit>(),
            child: LoginScreen(extra: extra.isEmpty ? null : extra),
          );
        },
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<RegisterCubit>(),
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/otp',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final phone = extra['phone'] as String;
          final isForgotPassword = extra['isForgotPassword'] as bool? ?? false;
          return BlocProvider(
            create: (context) => getIt<OtpCubit>(),
            child: OtpScreen(phone: phone, isForgotPassword: isForgotPassword),
          );
        },
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ForgotPasswordCubit>(),
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/new-password',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final phone = extra['phone'] as String;
          final otp = extra['otp'] as String;
          return BlocProvider(
            create: (context) => getIt<ResetPasswordCubit>(),
            child: NewPasswordScreen(phone: phone, otp: otp),
          );
        },
      ),
      GoRoute(
        path: '/reset-success',
        builder: (context, state) => const ResetSuccessScreen(),
      ),
      GoRoute(
        path: '/register-success',
        builder: (context, state) => const RegisterSuccessScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: '/subcategories',
        builder: (context, state) {
          final category = state.extra as CategoryEntity?;
          final type = state.uri.queryParameters['type'];
          final name = state.uri.queryParameters['name'];
          return SubcategoriesScreen(
            category: category,
            type: type,
            name: name,
          );
        },
      ),
      GoRoute(
        path: '/category-ads',
        builder: (context, state) {
          final category = state.extra as CategoryEntity?;
          final categoryId = int.tryParse(
            state.uri.queryParameters['id'] ?? '',
          );
          final categoryName = state.uri.queryParameters['name'];
          return CategoryAdsScreen(
            category: category,
            categoryId: categoryId,
            categoryName: categoryName,
          );
        },
      ),
      GoRoute(
        path: '/featured-ads',
        builder: (context, state) {
          return CategoryAdsScreen(
            isFeatured: true,
            categoryName: tr('featured_ads'),
          );
        },
      ),

      GoRoute(
        path: '/ad-details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final isMyAd = state.uri.queryParameters['isMyAd'] == 'true';
          final isEditing = state.uri.queryParameters['edit'] == 'true';
          return AdDetailsScreen(id: id, isMyAd: isMyAd, isEditing: isEditing);
        },
      ),
      GoRoute(
        path: '/my-ads',
        builder: (context, state) => const MyAdsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ProfileCubit>(),
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/personal-data',
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<ProfileCubit>()..getProfile(),
            ),
            BlocProvider(create: (context) => getIt<PersonalDataCubit>()),
          ],
          child: const PersonalDataScreen(),
        ),
      ),
      GoRoute(
        path: '/contact-us',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ContactUsCubit>(),
          child: const ContactUsScreen(),
        ),
      ),
      GoRoute(
        path: '/app-settings',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<ProfileCubit>(),
          child: const AppSettingsScreen(),
        ),
      ),
      GoRoute(
        path: '/terms',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AppInfoCubit>()..getTerms(),
          child: const TermsScreen(),
        ),
      ),
      GoRoute(
        path: '/about-us',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AppInfoCubit>()..getAboutUs(),
          child: const AboutUsScreen(),
        ),
      ),
      GoRoute(
        path: '/how-we-work',
        builder: (context, state) => const HowWeWorkScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AppInfoCubit>()..getPrivacyPolicy(),
          child: const PrivacyPolicyScreen(),
        ),
      ),
      GoRoute(
        path: '/faqs',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AppInfoCubit>()..getFaqs(),
          child: const FaqsScreen(),
        ),
      ),
      GoRoute(
        path: '/create-ad',
        builder: (context, state) => const CreateAdScreen(),
      ),
      GoRoute(
        path: '/create-ad-success',
        builder: (context, state) => const CreateAdSuccessScreen(),
      ),
      GoRoute(
        path: '/edit-ad',
        builder: (context, state) {
          final ad = state.extra as AdDetailsEntity;
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => getIt<EditAdCubit>()),
              BlocProvider(
                create: (context) => getIt<AdCategorySelectionCubit>(),
              ),
            ],
            child: EditAdScreen(ad: ad),
          );
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<NotificationsCubit>(),
          child: const NotificationsScreen(),
        ),
      ),
    ],
  );
}
