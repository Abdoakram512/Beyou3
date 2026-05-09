import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories({
    String? search,
    String? type,
    String? parentId,
  }) => safeCall(
    () => remoteDataSource.getCategories(
      search: search,
      type: type,
      parentId: parentId,
    ),
  );
}
