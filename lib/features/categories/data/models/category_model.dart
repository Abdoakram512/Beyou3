import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.type,
    required super.image,
    super.parentId,
    required super.hasChildren,
    required super.children,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      image: json['image'],
      parentId: json['parent_id'],
      hasChildren:
          json['has_children'] == true ||
          json['has_children'] == 1 ||
          json['has_children'] == '1' ||
          json['has_children'] == 'true' ||
          (json['children'] != null && (json['children'] as List).isNotEmpty),
      children: json['children'] != null
          ? List<CategoryModel>.from(
              json['children'].map((x) => CategoryModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'parent_id': parentId,
      'has_children': hasChildren,
      'children': children.map((x) => (x as CategoryModel).toJson()).toList(),
    };
  }
}
