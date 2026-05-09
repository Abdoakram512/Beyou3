import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/category_repository.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoryRepository repository;

  CategoriesCubit({required this.repository}) : super(CategoriesInitial());

  Future<void> getCategories({
    String? search,
    String? type,
    String? parentId,
  }) async {
    emit(CategoriesLoading());
    final result = await repository.getCategories(
      search: search,
      type: type,
      parentId: parentId,
    );
    result.fold((failure) => emit(CategoriesError(failure.message)), (
      categories,
    ) {
      if ((search != null && search.isNotEmpty) ||
          (type != null && type.isNotEmpty) ||
          (parentId != null && parentId.isNotEmpty)) {
        emit(CategoriesLoaded(categories));
      } else {
        final rootCategories = categories
            .where((c) => c.parentId == null)
            .toList();
        emit(CategoriesLoaded(rootCategories));
      }
    });
  }
}
