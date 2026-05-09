import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../banners/presentation/cubit/banners_cubit.dart';
import '../../../banners/presentation/cubit/banners_state.dart';
import '../../../banners/presentation/widgets/banners_slider.dart';

class HomeBannersSection extends StatelessWidget {
  const HomeBannersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: RepaintBoundary(
        child: BlocBuilder<BannersCubit, BannersState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            if (state is BannersLoading) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Container(
                  height: 0.25.sh,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.handleGrey,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: const AppLoadingIndicator(),
                ),
              );
            } else if (state is BannersLoaded) {
              return BannersSlider(banners: state.banners);
            } else if (state is BannersError) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  state.message,
                  style: AppTextStyles.font14GreyRegular.copyWith(
                    color: AppColors.error,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
