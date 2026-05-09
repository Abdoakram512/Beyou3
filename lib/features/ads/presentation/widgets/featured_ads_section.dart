import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feedback/app_error_state.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../cubit/featured_ads_cubit.dart';
import '../cubit/featured_ads_state.dart';
import 'ad_card.dart';

class FeaturedAdsSection extends StatelessWidget {
  const FeaturedAdsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tr('featured_ads'),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.authSectionTitleColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push('/featured-ads');
                },
                child: Text(
                  tr('view_all'),
                  style: TextStyle(
                    color: AppColors.greyText,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 0.35.sh,
          child: BlocBuilder<FeaturedAdsCubit, FeaturedAdsState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              if (state is FeaturedAdsLoading) {
                return const AppLoadingIndicator();
              } else if (state is FeaturedAdsLoaded) {
                if (state.ads.isEmpty) {
                  return const SizedBox.shrink();
                }
                return RepaintBoundary(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    scrollDirection: Axis.horizontal,
                    itemCount: state.ads.length,
                    separatorBuilder: (context, index) => SizedBox(width: 16.w),
                    itemBuilder: (context, index) {
                      return AdCard(ad: state.ads[index]);
                    },
                  ),
                );
              } else if (state is FeaturedAdsError) {
                return AppErrorState(
                  message: state.message,
                  onRetry: () =>
                      context.read<FeaturedAdsCubit>().getFeaturedAds(),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}
