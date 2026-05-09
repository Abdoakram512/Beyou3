import 'dart:io';
import 'package:dio/dio.dart';

class CreateAdRequestModel {
  final int categoryId;
  final String title;
  final String description;
  final String price;
  final File mainImage;
  final List<File> extraImages;
  final String? address;
  final String? lat;
  final String? lng;
  final String? area;
  final String? purpose;
  final int? brandId;

  CreateAdRequestModel({
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.mainImage,
    this.extraImages = const [],
    this.address,
    this.lat,
    this.lng,
    this.area,
    this.purpose,
    this.brandId,
  });

  Future<Map<String, dynamic>> toMap() async {
    final map = <String, dynamic>{
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'images[0]': await MultipartFile.fromFile(
        mainImage.path,
        filename: mainImage.path.split('/').last,
      ),
    };

    for (int i = 0; i < extraImages.length; i++) {
      map['images[${i + 1}]'] = await MultipartFile.fromFile(
        extraImages[i].path,
        filename: extraImages[i].path.split('/').last,
      );
    }

    if (address != null) map['address'] = address;
    if (lat != null) map['lat'] = lat;
    if (lng != null) map['lng'] = lng;
    if (area != null) map['area'] = area;
    if (purpose != null) map['purpose'] = purpose;
    if (brandId != null) map['brand_id'] = brandId;

    return map;
  }
}
