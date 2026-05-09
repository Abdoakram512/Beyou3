import 'dart:io';
import 'package:equatable/equatable.dart';

enum CreateAdStatus { initial, loading, success, failure }

class CreateAdState extends Equatable {
  final CreateAdStatus status;
  final String? errorMessage;
  final int currentStep;

  // Step 1 Data
  final int? categoryId;
  final String title;
  final String description;

  // Step 2 Data
  final String price;
  final String? lat;
  final String? lng;
  final String? address;
  final String? area;
  final String? purpose;
  final int? brandId;

  // Step 3 Data
  final File? mainImage;
  final List<File> extraImages;

  const CreateAdState({
    this.status = CreateAdStatus.initial,
    this.errorMessage,
    this.currentStep = 0,
    this.categoryId,
    this.title = '',
    this.description = '',
    this.price = '',
    this.lat,
    this.lng,
    this.address,
    this.area,
    this.purpose,
    this.brandId,
    this.mainImage,
    this.extraImages = const [],
  });

  /// دالة بسيطة ومقروءة لتحديث البيانات دون تعقيد الـ Sentinel
  CreateAdState copyWith({
    CreateAdStatus? status,
    String? errorMessage,
    bool clearError = false, // نستخدم ده لو عايزين نمسح رسالة الخطأ القديمة
    int? currentStep,
    int? categoryId,
    String? title,
    String? description,
    String? price,
    String? lat,
    bool clearLocation = false, // نعلم عليه true لو عايزين نمسح اللوكيشن
    String? lng,
    String? address,
    String? area,
    String? purpose,
    int? brandId,
    File? mainImage,
    List<File>? extraImages,
  }) {
    return CreateAdState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentStep: currentStep ?? this.currentStep,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,

      // بنمسح المكان لو المبرمج عمل clearLocation = true
      lat: clearLocation ? null : (lat ?? this.lat),
      lng: clearLocation ? null : (lng ?? this.lng),
      address: clearLocation ? null : (address ?? this.address),

      area: area ?? this.area,
      purpose: purpose ?? this.purpose,
      brandId: brandId ?? this.brandId,
      mainImage: mainImage ?? this.mainImage,
      extraImages: extraImages ?? this.extraImages,
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    currentStep,
    categoryId,
    title,
    description,
    price,
    lat,
    lng,
    address,
    area,
    purpose,
    brandId,
    mainImage,
    extraImages,
  ];
}
