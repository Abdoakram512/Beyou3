import 'package:equatable/equatable.dart';

class AppInfoModel extends Equatable {
  final String title;
  final String description;
  final String image;

  const AppInfoModel({
    required this.title,
    required this.description,
    required this.image,
  });

  factory AppInfoModel.fromJson(Map<String, dynamic> json) {
    return AppInfoModel(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'description': description, 'image': image};
  }

  @override
  List<Object?> get props => [title, description, image];
}
