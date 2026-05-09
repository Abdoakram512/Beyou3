import 'dart:io';
import 'package:dio/dio.dart';

class EditAdRequestModel {
  final int adId;
  final int categoryId;
  final String title;
  final String description;
  final String price;
  final List<File> images;
  final List<String> deletedImageIds;
  final String address;
  final String lat;
  final String lng;
  final String area;
  final String purpose;
  final String brandId;

  EditAdRequestModel({
    required this.adId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.price,
    required this.images,
    required this.deletedImageIds,
    required this.address,
    required this.lat,
    required this.lng,
    required this.area,
    required this.purpose,
    required this.brandId,
  });

  Future<Map<String, dynamic>> toFormData() async {
    final Map<String, dynamic> data = {
      'category_id': categoryId,
      'title': title,
      'description': description,
      'price': price,
      'address': address,
      'lat': lat,
      'lng': lng,
      'area': area,
      'purpose': purpose,
      'brand_id': brandId,
    };

    // Add deleted image IDs
    for (int i = 0; i < deletedImageIds.length; i++) {
      data['deleted_image_ids[$i]'] = deletedImageIds[i];
    }

    // Add new images
    for (int i = 0; i < images.length; i++) {
      data['images[$i]'] = await MultipartFile.fromFile(
        images[i].path,
        filename: images[i].path.split('/').last,
      );
    }

    return data;
  }
}
