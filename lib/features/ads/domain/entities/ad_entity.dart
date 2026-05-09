import 'package:equatable/equatable.dart';

class AdEntity extends Equatable {
  final int id;
  final String title;
  final num price; // Using num to handle both int and double
  final String? image;
  final bool isFeatured;
  final String? location;
  final String? createdAt;
  final String? purpose;
  final String? status;
  final AdCategoryEntity? category;

  const AdEntity({
    required this.id,
    required this.title,
    required this.price,
    this.image,
    this.isFeatured = false,
    this.location,
    this.createdAt,
    this.purpose,
    this.status,
    this.category,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    image,
    isFeatured,
    location,
    createdAt,
    purpose,
    status,
    category,
  ];

  AdEntity copyWith({
    int? id,
    String? title,
    num? price,
    String? image,
    bool? isFeatured,
    String? location,
    String? createdAt,
    String? purpose,
    String? status,
    AdCategoryEntity? category,
  }) {
    return AdEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      image: image ?? this.image,
      isFeatured: isFeatured ?? this.isFeatured,
      location: location ?? this.location,
      createdAt: createdAt ?? this.createdAt,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      category: category ?? this.category,
    );
  }
}

class AdCategoryEntity extends Equatable {
  final int id;
  final String name;
  final String type;

  const AdCategoryEntity({
    required this.id,
    required this.name,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, type];
}
