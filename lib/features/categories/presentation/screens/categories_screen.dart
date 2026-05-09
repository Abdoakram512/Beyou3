import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/dependency_injection/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/widgets/feedback/app_empty_state.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_images.dart';
import '../../../../core/widgets/feedback/app_refresh_indicator.dart';

import '../widgets/categories_grid.dart';

class CategoriesScreen extends StatefulWidget {
  final String? type;
  const CategoriesScreen({super.key, this.type});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<CategoriesCubit>()..getCategories(type: widget.type),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoHeader(),
              _buildHeaderText(),
              SizedBox(height: 16.h),
              Expanded(
                child: AppRefreshIndicator(
                  onRefresh: () async {
                    await context.read<CategoriesCubit>().getCategories(
                      type: widget.type,
                    );
                  },
                  child: BlocBuilder<CategoriesCubit, CategoriesState>(
                    builder: (context, state) {
                      if (state is CategoriesLoading) {
                        return const AppLoadingIndicator();
                      } else if (state is CategoriesError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: AppColors.error),
                          ),
                        );
                      } else if (state is CategoriesLoaded) {
                        final categories = state.rootCategories;
                        if (categories.isEmpty) {
                          return AppEmptyState(
                            title: tr('no_categories_found'),
                            lottieAsset: 'assets/animations/Empty.json',
                          );
                        }
                        return CategoriesGrid(categories: categories);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return SizedBox(
      height: 120.h,
      child: OverflowBox(
        maxHeight: 160.h,
        child: Image.asset(AppImages.headerLogo, height: 160.h),
      ),
    );
  }

  Widget _buildHeaderText() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0.h, 20.w, 10.h),
      child: Text(
        tr('all_categories'),
        style: TextStyle(
          fontSize: 22.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }
}
