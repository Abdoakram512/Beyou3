import 'package:beyou3/core/widgets/feedback/app_snack_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/config/dependency_injection/di.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/feedback/app_error_state.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/feedback/app_refresh_indicator.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../cubit/ads_list_cubit.dart';
import '../cubit/ads_list_state.dart';
import '../widgets/category_ads_search_and_filter_bar.dart';
import '../widgets/category_ads_grid.dart';
import '../widgets/category_ads_empty_state.dart';

class CategoryAdsScreen extends StatefulWidget {
  final CategoryEntity? category;
  final int? categoryId;
  final String? categoryName;
  final bool? isFeatured;

  const CategoryAdsScreen({
    super.key,
    this.category,
    this.categoryId,
    this.categoryName,
    this.isFeatured,
  });

  @override
  State<CategoryAdsScreen> createState() => _CategoryAdsScreenState();
}

class _CategoryAdsScreenState extends State<CategoryAdsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedPurpose;
  num? _minPrice;
  num? _maxPrice;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom) {
      final cubit = context.read<AdsListCubit>();
      cubit.loadMoreAds(
        categoryId: widget.categoryId ?? widget.category?.id,
        search: _searchController.text,
        purpose: _selectedPurpose,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        isFeatured: widget.isFeatured,
      );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAds(BuildContext blocContext) async {
    // ✅ Fix 3.7: AppSnackBar for consistent filter feedback
    AppSnackBar.showInfo(
      context,
      tr(
        'filtering_status',
        args: [(_minPrice ?? 0).toString(), (_maxPrice ?? 0).toString()],
      ),
    );

    await blocContext.read<AdsListCubit>().getAds(
      categoryId: widget.categoryId ?? widget.category?.id,
      search: _searchController.text,
      purpose: _selectedPurpose,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      isFeatured: widget.isFeatured,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveCategoryId = widget.categoryId ?? widget.category?.id;
    final effectiveCategoryName =
        widget.categoryName ?? widget.category?.name ?? '';

    return BlocProvider(
      create: (context) => getIt<AdsListCubit>()
        ..getAds(
          categoryId: effectiveCategoryId,
          isFeatured: widget.isFeatured,
        ),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: effectiveCategoryName),
          body: Column(
            children: [
              SizedBox(height: 8.h),
              CategoryAdsSearchAndFilterBar(
                searchController: _searchController,
                selectedPurpose: _selectedPurpose,
                minPrice: _minPrice,
                maxPrice: _maxPrice,
                onFilterChanged: (purpose, min, max) {
                  setState(() {
                    _selectedPurpose = purpose;
                    _minPrice = min;
                    _maxPrice = max;
                  });
                  _getAds(context);
                },
                onSearchChanged: () => _getAds(context),
              ),
              Expanded(
                child: AppRefreshIndicator(
                  onRefresh: () => _getAds(context),
                  child: BlocBuilder<AdsListCubit, AdsListState>(
                    builder: (context, state) {
                      if (state is AdsListLoading) {
                        return const AppLoadingIndicator();
                      } else if (state is AdsListError) {
                        return AppErrorState(
                          message: state.message,
                          onRetry: () => _getAds(context),
                        );
                      } else if (state is AdsListLoaded) {
                        if (state.ads.isEmpty) {
                          final isFiltered =
                              _selectedPurpose != null ||
                              _minPrice != null ||
                              _maxPrice != null ||
                              _searchController.text.isNotEmpty;

                          return CategoryAdsEmptyState(
                            isFiltered: isFiltered,
                            onReset: () {
                              setState(() {
                                _selectedPurpose = null;
                                _minPrice = null;
                                _maxPrice = null;
                                _searchController.clear();
                              });
                              _getAds(context);
                            },
                          );
                        }
                        return CategoryAdsGrid(
                          ads: state.ads,
                          scrollController: _scrollController,
                          isLoadingMore: state.isLoadingMore,
                        );
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
}
