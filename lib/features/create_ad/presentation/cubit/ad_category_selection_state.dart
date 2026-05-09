import '../../../categories/domain/entities/category_entity.dart';
import '../../data/models/brand_model.dart';

enum CategorySelectionStatus { initial, success, failure }

class AdCategorySelectionState {
  final CategorySelectionStatus status;
  final String? errorMessage;

  // Hierarchical Data
  final List<CategoryEntity> selectedCategoryPath;
  final Map<int, List<CategoryEntity>> subcategoriesMap;
  final Set<int> loadingLevels;

  // Brands
  final bool isBrandsLoading;
  final List<BrandModel> brands;
  final String? brandsErrorMessage;

  const AdCategorySelectionState({
    this.status = CategorySelectionStatus.initial,
    this.errorMessage,
    this.selectedCategoryPath = const [],
    this.subcategoriesMap = const {},
    this.loadingLevels = const {},
    this.isBrandsLoading = false,
    this.brands = const [],
    this.brandsErrorMessage,
  });

  AdCategorySelectionState copyWith({
    CategorySelectionStatus? status,
    String? errorMessage,
    List<CategoryEntity>? selectedCategoryPath,
    Map<int, List<CategoryEntity>>? subcategoriesMap,
    Set<int>? loadingLevels,
    bool? isBrandsLoading,
    List<BrandModel>? brands,
    String? brandsErrorMessage,
  }) {
    return AdCategorySelectionState(
      status: status ?? this.status,
      errorMessage:
          errorMessage ??
          this.errorMessage, // Will not null out easily, but acceptable for error strings
      selectedCategoryPath: selectedCategoryPath ?? this.selectedCategoryPath,
      subcategoriesMap: subcategoriesMap ?? this.subcategoriesMap,
      loadingLevels: loadingLevels ?? this.loadingLevels,
      isBrandsLoading: isBrandsLoading ?? this.isBrandsLoading,
      brands: brands ?? this.brands,
      brandsErrorMessage: brandsErrorMessage ?? this.brandsErrorMessage,
    );
  }

  /// Helper getter for the deepest selected category
  CategoryEntity? get deepestCategory {
    if (selectedCategoryPath.isEmpty) return null;
    return selectedCategoryPath.last;
  }
}
