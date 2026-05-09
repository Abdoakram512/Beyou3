import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/config/dependency_injection/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feedback/app_refresh_indicator.dart';
import '../../../ads/presentation/cubit/featured_ads_cubit.dart';
import '../../../banners/presentation/cubit/banners_cubit.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../../core/theme/app_images.dart';
import '../widgets/home_banners_section.dart';
import '../widgets/home_categories_section.dart';
import '../widgets/home_search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _debounce;
  final ValueNotifier<String> _searchQueryNotifier = ValueNotifier<String>('');

  void _onSearchChanged(BuildContext context, String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchQueryNotifier.value = query;
      context.read<CategoriesCubit>().getCategories(search: query);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchQueryNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<CategoriesCubit>()..getCategories(),
        ),
        BlocProvider(create: (context) => getIt<BannersCubit>()..getBanners()),
        BlocProvider(
          create: (context) => getIt<FeaturedAdsCubit>()..getFeaturedAds(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: ValueListenableBuilder<String>(
            valueListenable: _searchQueryNotifier,
            builder: (context, searchQuery, _) {
              return AppRefreshIndicator(
                onRefresh: () async {
                  final categoriesCubit = context.read<CategoriesCubit>();
                  final bannersCubit = context.read<BannersCubit>();
                  final featuredAdsCubit = context.read<FeaturedAdsCubit>();

                  await Future.wait([
                    categoriesCubit.getCategories(search: searchQuery),
                    if (searchQuery.isEmpty) bannersCubit.getBanners(),
                    if (searchQuery.isEmpty) featuredAdsCubit.getFeaturedAds(),
                  ]);
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 120.h,
                        child: OverflowBox(
                          maxHeight: 160.h,
                          child: Image.asset(
                            AppImages.headerLogo,
                            height: 160.h,
                          ),
                        ),
                      ),
                    ),

                    // Banners Section
                    if (searchQuery.isEmpty) ...[
                      const HomeBannersSection(),
                      SliverToBoxAdapter(child: SizedBox(height: 4.h)),
                    ],

                    SliverToBoxAdapter(child: SizedBox(height: 12.h)),

                    // Search Bar
                    HomeSearchBar(
                      onChanged: (value) => _onSearchChanged(context, value),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),

                    // Content Section (Categories / Search Results)
                    HomeCategoriesSection(searchQuery: searchQuery),

                    SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
