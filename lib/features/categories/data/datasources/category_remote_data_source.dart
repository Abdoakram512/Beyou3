import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories({
    String? search,
    String? type,
    String? parentId,
  });
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiConsumer apiConsumer;

  CategoryRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<CategoryModel>> getCategories({
    String? search,
    String? type,
    String? parentId,
  }) async {
    final Map<String, dynamic> queryParameters = {};

    if (type != null && type.isNotEmpty) {
      queryParameters['type'] = type;
    }

    if (parentId != null && parentId.isNotEmpty) {
      queryParameters['parent_id'] = parentId;
    } else if (type == null && (search == null || search.isEmpty)) {
      // Only force 'null' parent_id if no type, parentId, or search query is provided (fetch roots)
      queryParameters['parent_id'] = 'null';
    }

    // Always fetch children for subcategory screens or home sections
    queryParameters['with_children'] = 'true';

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    final response = await apiConsumer.get(
      EndPoints.categories,
      queryParameters: queryParameters,
    );

    final List data;
    if (response is Map && response.containsKey('data')) {
      data = response['data'] as List;
    } else if (response is List) {
      data = response;
    } else {
      data = [];
    }

    return data.map((category) => CategoryModel.fromJson(category)).toList();
  }
}
