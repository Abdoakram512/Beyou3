import 'package:get_it/get_it.dart';
import 'modules/auth_di.dart';
import 'modules/ads_di.dart';
import 'modules/profile_di.dart';
import 'modules/banners_di.dart';
import 'modules/categories_di.dart';
import 'modules/create_ad_di.dart';
import 'modules/edit_ad_di.dart';
import 'modules/notifications_di.dart';
import 'modules/core_di.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Core Shared Services (Network, SecureStorage, etc.)
  await initCoreDI();

  // 2. Feature Specific Modules
  await initAuthDI();
  await initCategoriesDI();
  await initBannersDI();
  await initProfileDI();
  await initAdsDI();
  await initCreateAdDI();
  await initEditAdDI();
  await initNotificationsDI();
}
