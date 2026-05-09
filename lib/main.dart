import 'package:beyou3/firebase_options.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:beyou3/core/config/routers/app_router.dart';
import 'package:beyou3/core/helpers/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:beyou3/core/config/dependency_injection/di.dart';
import 'package:beyou3/features/auth/presentation/cubit/auth_status/auth_status_cubit.dart';
import 'package:beyou3/core/theme/app_theme.dart';
import 'package:beyou3/core/theme/app_scroll_behavior.dart';

import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:beyou3/core/services/notification_service.dart';
import 'package:beyou3/core/helpers/app_logger.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  AppLogger.log(
    'Handling background message: ${message.messageId}',
    name: 'FirebaseMessaging',
  );
}

final _appRouter = AppRouter();

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // 1. Initialize Firebase & Notifications
      try {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform
        );

        // Previously split into two handlers; the second was silently overwriting the first.
        FlutterError.onError = (errorDetails) {
          FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
          AppLogger.error(
            'Flutter Error',
            errorDetails.exception,
            errorDetails.stack,
          );
        };

        // Pass all uncaught async errors to Crashlytics
        PlatformDispatcher.instance.onError = (error, stack) {
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
          AppLogger.error('Unhandled Async Error', error, stack);
          return true;
        };

        FirebaseMessaging.onBackgroundMessage(
          firebaseMessagingBackgroundHandler,
        );

        await initDependencies();
        await getIt<NotificationService>().init();
      } catch (e, stack) {
        AppLogger.error(
          'Firebase or Notifications initialization failed',
          e,
          stack,
        );
      }

      // 2. Initialize Core Services
      await EasyLocalization.ensureInitialized();
      await SharedPrefHelper.init();

      runApp(
        EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('ar'),
          startLocale: const Locale('ar'),
          child: const MyApp(),
        ),
      );
    },
    (error, stack) {
      AppLogger.error('Unhandled Global Error', error, stack);
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Register dependency on EasyLocalization here so the entire tree rebuilds
    final locale = context.locale;

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => getIt<AuthStatusCubit>()..checkAuthStatus(),
          child: MaterialApp.router(
            scrollBehavior: const AppScrollBehavior(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: locale,
            debugShowCheckedModeBanner: false,
            routerConfig: _appRouter.router,
            theme: AppTheme.lightTheme,
            builder: (context, child) {
              return child ?? const SizedBox.shrink(); // OfflineWrapper تعطل
            },
          ),
        );
      },
    );
  }
}
