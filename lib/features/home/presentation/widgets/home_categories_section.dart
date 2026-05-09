import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../ads/presentation/widgets/featured_ads_section.dart';
import '../../../categories/presentation/cubit/categories_cubit.dart';
import '../../../categories/presentation/cubit/categories_state.dart';
import '../../../categories/presentation/widgets/category_card.dart';
import '../../../categories/presentation/widgets/category_section.dart';

class HomeCategoriesSection extends StatelessWidget {
  final String searchQuery;

  const HomeCategoriesSection({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const SliverToBoxAdapter(
            child: Center(child: AppLoadingIndicator()),
          );
        } else if (state is CategoriesError) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                state.message,
                style: AppTextStyles.font14GreyRegular.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          );
        } else if (state is CategoriesLoaded) {
          if (searchQuery.isNotEmpty) {
            // Search Results View
            if (state.rootCategories.isEmpty) {
              return SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    tr(
                      'no_results_found_for',
                      args: [searchQuery],
                    ),
                    style: AppTextStyles.font16GreyRegular,
                  ),
                ),
              );
            }
            return SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 0.8,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return CategoryCard(
                      category: state.rootCategories[index],
                      width: double.infinity,
                    );
                  },
                  childCount: state.rootCategories.length,
                ),
              ),
            );
          } else {
            // Home View (Sections)
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index < state.rootCategories.length) {
                    return CategorySection(
                      rootCategory: state.rootCategories[index],
                    );
                  }
                  return const FeaturedAdsSection();
                },
                childCount: state.rootCategories.length + 1,
              ),
            );
          }
        }
        return const SliverToBoxAdapter(
          child: SizedBox.shrink(),
        );
      },
    );
  }
}
