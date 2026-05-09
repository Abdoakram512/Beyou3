import '../../domain/entities/ad_entity.dart';

class AdModel extends AdEntity {
  const AdModel({
    required super.id,
    required super.title,
    required super.price,
    super.image,
    super.isFeatured,
    super.location,
    super.createdAt,
    super.purpose,
    super.status,
    super.category,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      price: json['price'] is num
          ? json['price']
          : num.tryParse(json['price']?.toString() ?? '0') ?? 0,
      image: json['image']?.toString(),
      isFeatured: json['is_featured'] == true || json['is_featured'] == 1,
      location: json['location'] is Map
          ? json['location']['address']?.toString()
          : json['location']?.toString(),
      createdAt: json['created_at']?.toString(),
      purpose: json['purpose']?.toString(),
      status: json['status']?.toString(),
      category: json['category'] is Map
          ? AdCategoryModel.fromJson(json['category'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'image': image,
      'is_featured': isFeatured,
      'location': location,
      'created_at': createdAt,
      'purpose': purpose,
      'status': status,
      'category': category != null
          ? (category as AdCategoryModel).toJson()
          : null,
    };
  }
}

class AdCategoryModel extends AdCategoryEntity {
  const AdCategoryModel({
    required super.id,
    required super.name,
    required super.type,
  });

  factory AdCategoryModel.fromJson(Map<String, dynamic> json) {
    return AdCategoryModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'type': type};
  }
}
