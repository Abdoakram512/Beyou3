import '../../domain/entities/ad_details_entity.dart';
import 'ad_model.dart';

class AdDetailsModel extends AdDetailsEntity {
  const AdDetailsModel({
    required super.id,
    required super.title,
    required super.price,
    super.description,
    super.purpose,
    super.status,
    super.category,
    super.brand,
    super.area,
    super.location,
    super.user,
    super.images,
    super.createdAt,
  });

  factory AdDetailsModel.fromJson(Map<String, dynamic> json) {
    List<AdImageModel> parsedImages = [];
    if (json['images'] is List) {
      for (var v in json['images']) {
        if (v is Map<String, dynamic>) {
          parsedImages.add(AdImageModel.fromJson(v));
        }
      }
    }

    return AdDetailsModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      title: json['title']?.toString() ?? '',
      price: json['price'] is num
          ? json['price']
          : num.tryParse(json['price']?.toString() ?? '0') ?? 0,
      description: json['description']?.toString(),
      purpose: json['purpose']?.toString(),
      status: json['status']?.toString(),
      category: json['category'] is Map<String, dynamic>
          ? AdCategoryModel.fromJson(json['category'])
          : null,
      brand: json['brand']?.toString(),
      area: json['area']?.toString(),
      location: json['location'] != null
          ? (json['location'] is String
                ? AdLocationModel(address: json['location'])
                : json['location'] is Map<String, dynamic>
                ? AdLocationModel.fromJson(json['location'])
                : null)
          : null,
      user: json['user'] is Map<String, dynamic>
          ? AdOwnerModel.fromJson(json['user'])
          : null,
      images: parsedImages,
      createdAt: json['created_at']?.toString(),
    );
  }
}

class AdLocationModel extends AdLocationEntity {
  const AdLocationModel({super.address, super.lat, super.lng});

  factory AdLocationModel.fromJson(Map<String, dynamic> json) {
    return AdLocationModel(
      address: json['address']?.toString(),
      lat: json['lat'] is num
          ? json['lat']
          : num.tryParse(json['lat']?.toString() ?? ''),
      lng: json['lng'] is num
          ? json['lng']
          : num.tryParse(json['lng']?.toString() ?? ''),
    );
  }
}

class AdOwnerModel extends AdOwnerEntity {
  const AdOwnerModel({
    required super.id,
    required super.name,
    super.phone,
    super.email,
  });

  factory AdOwnerModel.fromJson(Map<String, dynamic> json) {
    return AdOwnerModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
    );
  }
}

class AdImageModel extends AdImageEntity {
  const AdImageModel({required super.id, required super.url, super.isMain});

  factory AdImageModel.fromJson(Map<String, dynamic> json) {
    return AdImageModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      url: json['url']?.toString() ?? '',
      isMain: json['is_main'] == true || json['is_main'] == 1,
    );
  }
}
