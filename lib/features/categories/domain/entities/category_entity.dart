import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String type;
  final String? image;
  final String? parentId; // nullable String
  final bool hasChildren;
  final List<CategoryEntity> children;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    this.parentId,
    required this.hasChildren,
    required this.children,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    type,
    image,
    parentId,
    hasChildren,
    children,
  ];
}
