import 'package:beyou3/core/config/dependency_injection/di.dart';
import 'package:beyou3/core/theme/app_colors.dart';
import 'package:beyou3/core/widgets/feedback/app_empty_state.dart';
import 'package:beyou3/core/widgets/feedback/app_error_state.dart';
import 'package:beyou3/core/widgets/common/custom_app_bar.dart';
import 'package:beyou3/features/ads/presentation/cubit/my_ads_cubit.dart';
import 'package:beyou3/features/ads/presentation/cubit/my_ads_state.dart';
import 'package:beyou3/core/widgets/feedback/app_refresh_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../widgets/my_ads_tab_bar.dart';
import '../widgets/my_ads_list_view.dart';
import '../widgets/my_ads_shimmer_list.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MyAdsCubit>()..getMyAds(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: tr('my_ads'), showBackButton: false),
        body: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const MyAdsTabBar(),
              Expanded(
                child: BlocBuilder<MyAdsCubit, MyAdsState>(
                  builder: (context, state) {
                    if (state is MyAdsLoading) {
                      return const MyAdsShimmerList();
                    } else if (state is MyAdsError) {
                      return AppErrorState(
                        message: state.message,
                        onRetry: () => context.read<MyAdsCubit>().getMyAds(),
                      );
                    } else if (state is MyAdsSuccess) {
                      if (state.ads.isEmpty) {
                        return _buildEmptyState(context);
                      }
                      return TabBarView(
                        children: [
                          _buildAdsTab(context, state.ads, ['pending']),
                          _buildAdsTab(context, state.ads, [
                            'approved',
                            'active',
                          ]),
                          _buildAdsTab(context, state.ads, ['rejected']),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyState(
      title: tr('no_ads_yet'),
      subtitle: tr('start_adding_ads_now'),
      lottieAsset: 'assets/animations/Empty.json',
      icon: Icons.inbox_rounded,
      actionLabel: tr('add_ad'),
      onActionPressed: () => context.push('/create-ad'),
    );
  }

  Widget _buildAdsTab(BuildContext context, List ads, List<String> statuses) {
    final filteredAds = ads.where((ad) {
      final status = ad.status?.toLowerCase();
      return statuses.contains(status);
    }).toList();

    if (filteredAds.isEmpty) {
      return AppRefreshIndicator(
        onRefresh: () => context.read<MyAdsCubit>().getMyAds(),
        child: SingleChildScrollView(
          child: Container(
            height: 0.6.sh,
            alignment: Alignment.center,
            child: AppEmptyState(
              title: tr('no_ads_in_this_tab'),
              subtitle: tr('your_ads_will_appear_here'),
              lottieAsset: 'assets/animations/Empty.json',
            ),
          ),
        ),
      );
    }

    return AppRefreshIndicator(
      onRefresh: () => context.read<MyAdsCubit>().getMyAds(),
      child: MyAdsListView(ads: filteredAds),
    );
  }
}
