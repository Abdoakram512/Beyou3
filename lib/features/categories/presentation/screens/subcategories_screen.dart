import 'package:beyou3/core/widgets/common/custom_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/config/dependency_injection/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/category_entity.dart';
import '../../../ads/presentation/screens/category_ads_screen.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../widgets/category_card.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';

class SubcategoriesScreen extends StatefulWidget {
  final CategoryEntity? category;
  final String? type;
  final String? name;

  const SubcategoriesScreen({super.key, this.category, this.type, this.name});

  @override
  State<SubcategoriesScreen> createState() => _SubcategoriesScreenState();
}

class _SubcategoriesScreenState extends State<SubcategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = getIt<CategoriesCubit>();
        if (widget.type != null) {
          cubit.getCategories(type: widget.type);
        } else if (widget.category != null) {
          cubit.getCategories(parentId: widget.category!.id.toString());
        }
        return cubit;
      },
      child: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesLoaded &&
              state.rootCategories.isEmpty &&
              widget.category != null) {
            return CategoryAdsScreen(
              category: widget.category,
              categoryId: widget.category!.id,
              categoryName: widget.name ?? widget.category!.name,
            );
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppBar(
              title: widget.name ?? widget.category?.name ?? '',
            ),
            body: _buildBody(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(CategoriesState state) {
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
      final items = state.rootCategories;
      if (items.isEmpty) {
        return Center(
          child: Text(
            tr('no_subcategories_found'),
            style: TextStyle(fontSize: 16.sp, color: AppColors.greyText),
          ),
        );
      }
      return _buildGrid(items);
    } else if (widget.category != null) {
      if (widget.category!.children.isEmpty) {
        return const AppLoadingIndicator();
      }
      return _buildGrid(widget.category!.children);
    }
    return const SizedBox.shrink();
  }

  Widget _buildGrid(List<CategoryEntity> items) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.all(20.w),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 12.h,
              crossAxisSpacing: 12.w,
              childAspectRatio: 0.75,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              return CategoryCard(category: items[index]);
            }, childCount: items.length),
          ),
        ),
      ],
    );
  }
}
