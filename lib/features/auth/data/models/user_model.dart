import '../../../profile/data/models/profile_model.dart';

class UserModel {
  final ProfileModel profile;
  final String token;

  UserModel({required this.profile, required this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData =
        json['data'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>? ??
        json;

    return UserModel(
      profile: ProfileModel.fromJson(json),
      token:
          (json['token'] ?? json['access_token'] ?? userData['token'])
              ?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'user': profile.toJson(), 'token': token};
  }
}
