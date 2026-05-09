import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? image;
  final String? birthDate;

  const ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.image,
    this.birthDate,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    // Handle both flat and nested 'data' responses
    final data =
        json['data'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>? ??
        json;

    return ProfileModel(
      id: int.tryParse(data['id']?.toString() ?? '') ?? 0,
      name: data['name']?.toString() ?? '',
      email: data['email']?.toString() ?? '',
      phone: data['phone']?.toString(),
      image: data['image']?.toString(),
      birthDate: data['birth_date']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'image': image,
      'birth_date': birthDate,
    };
  }

  @override
  List<Object?> get props => [id, name, email, phone, image, birthDate];

  ProfileModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? image,
    String? birthDate,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      image: image ?? this.image,
      birthDate: birthDate ?? this.birthDate,
    );
  }
}
