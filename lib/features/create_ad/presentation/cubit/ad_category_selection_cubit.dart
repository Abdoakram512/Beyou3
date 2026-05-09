import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/domain/repositories/category_repository.dart';
import '../../domain/repositories/ad_repository.dart';
import 'ad_category_selection_state.dart';

class AdCategorySelectionCubit extends Cubit<AdCategorySelectionState> {
  final CategoryRepository _categoryRepository;
  final AdRepository _adRepository;

  AdCategorySelectionCubit(this._categoryRepository, this._adRepository)
    : super(const AdCategorySelectionState());

  static AdCategorySelectionCubit get(BuildContext context) =>
      BlocProvider.of<AdCategorySelectionCubit>(context);

  /// Select a category at a given depth level.
  /// Slices deeper selections, and triggers fetching for the next level if children exist.
  Future<void> selectCategoryAtLevel(int level, CategoryEntity category) async {
    // 1. Slice paths & subcategories map
    final newPath = state.selectedCategoryPath.length > level
        ? state.selectedCategoryPath.sublist(0, level)
        : List<CategoryEntity>.from(state.selectedCategoryPath);

    newPath.add(category);

    final newSubcategoriesMap = Map<int, List<CategoryEntity>>.from(
      state.subcategoriesMap,
    )..removeWhere((key, _) => key > level);

    // 2. Emit sliced state to refresh UI immediately
    emit(
      state.copyWith(
        selectedCategoryPath: newPath,
        subcategoriesMap: newSubcategoriesMap,
        brands: [], // Clear brands when category changes to prevent stale data
      ),
    );

    // 3. Fetch children or fetch brands if leaf node is vehicle
    if (category.hasChildren) {
      await _fetchSubcategories(level + 1, category.id);
    } else {
      if (category.type == 'vehicle') {
        await getBrands();
      }
    }
  }

  Future<void> _fetchSubcategories(int level, int parentId) async {
    final newLoadingSet = Set<int>.from(state.loadingLevels)..add(level);
    emit(state.copyWith(loadingLevels: newLoadingSet));

    final result = await _categoryRepository.getCategories(
      parentId: parentId.toString(),
    );

    final updatedLoadingSet = Set<int>.from(state.loadingLevels)..remove(level);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            loadingLevels: updatedLoadingSet,
            status: CategorySelectionStatus.failure,
            errorMessage: failure.message,
          ),
        );
      },
      (categories) {
        final updatedMap = Map<int, List<CategoryEntity>>.from(
          state.subcategoriesMap,
        )..[level] = categories;

        emit(
          state.copyWith(
            loadingLevels: updatedLoadingSet,
            subcategoriesMap: updatedMap,
            status: CategorySelectionStatus.success,
          ),
        );
      },
    );
  }

  Future<void> getBrands() async {
    emit(state.copyWith(isBrandsLoading: true));

    final result = await _adRepository.getBrands();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isBrandsLoading: false,
            brandsErrorMessage: failure.message,
          ),
        );
      },
      (loadedBrands) {
        emit(state.copyWith(isBrandsLoading: false, brands: loadedBrands));
      },
    );
  }

  /// Pre-populate hierarchy when editing an ad (optional future enhancement)
  void initializeWithHierarchy(
    List<CategoryEntity> path,
    Map<int, List<CategoryEntity>> childrenMap,
  ) {
    emit(
      state.copyWith(selectedCategoryPath: path, subcategoriesMap: childrenMap),
    );
  }
}
