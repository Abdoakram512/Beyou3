import 'package:equatable/equatable.dart';
import 'ad_entity.dart';

class AdDetailsEntity extends Equatable {
  final int id;
  final String title;
  final num price;
  final String? description;
  final String? purpose;
  final String? status;
  final AdCategoryEntity? category;
  final String? brand;
  final String? area;
  final String? rooms;
  final String? bathrooms;
  final String? finishing;

  final AdLocationEntity? location;
  final AdOwnerEntity? user;
  final List<AdImageEntity> images;
  final String? createdAt;

  const AdDetailsEntity({
    required this.id,
    required this.title,
    required this.price,
    this.description,
    this.purpose,
    this.status,
    this.category,
    this.brand,
    this.area,
    this.rooms,
    this.bathrooms,
    this.finishing,

    this.location,
    this.user,
    this.images = const [],
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    description,
    purpose,
    status,
    category,
    brand,
    area,
    rooms,
    bathrooms,
    finishing,

    location,
    user,
    images,
    createdAt,
  ];
}

class AdLocationEntity extends Equatable {
  final String? address;
  final num? lat;
  final num? lng;

  const AdLocationEntity({this.address, this.lat, this.lng});

  @override
  List<Object?> get props => [address, lat, lng];
}

class AdOwnerEntity extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final String? email;

  const AdOwnerEntity({
    required this.id,
    required this.name,
    this.phone,
    this.email,
  });

  @override
  List<Object?> get props => [id, name, phone, email];
}

class AdImageEntity extends Equatable {
  final int id;
  final String url;
  final bool isMain;

  const AdImageEntity({
    required this.id,
    required this.url,
    this.isMain = false,
  });

  @override
  List<Object?> get props => [id, url, isMain];
}
