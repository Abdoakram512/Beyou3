import '../../domain/entities/ads_response_entity.dart';
import 'ad_model.dart';
import 'pagination_model.dart';

class AdsResponseModel extends AdsResponseEntity {
  const AdsResponseModel({
    required super.ads,
    super.pagination,
  });

  factory AdsResponseModel.fromJson(Map<String, dynamic> json) {
    return AdsResponseModel(
      ads: (json['data'] as List? ?? [])
          .map((ad) => AdModel.fromJson(ad as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'] as Map<String, dynamic>)
          : null,
    );
  }

  // Top-level / static methods for Isolate parsing
  static AdsResponseModel parseAdsResponse(Map<String, dynamic> json) {
    return AdsResponseModel.fromJson(json);
  }

  static List<AdModel> parseAdModelList(List<dynamic> data) {
    return data.map((ad) => AdModel.fromJson(ad as Map<String, dynamic>)).toList();
  }
}
