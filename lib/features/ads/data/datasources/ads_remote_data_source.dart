import 'package:flutter/foundation.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/error/exceptions.dart';
import '../models/ad_details_model.dart';
import '../models/ad_model.dart';
import '../models/ads_response_model.dart';

abstract class AdsRemoteDataSource {
  Future<AdsResponseModel> getAds({
    String? search,
    int? categoryId,
    num? minPrice,
    num? maxPrice,
    String? purpose,
    bool? isFeatured,
    int? page,
  });
  Future<AdDetailsModel> getAdDetails(String id);
  Future<AdDetailsModel> getMyAdDetails(String id);
  Future<List<AdModel>> getMyAds();
}

class AdsRemoteDataSourceImpl implements AdsRemoteDataSource {
  final ApiConsumer apiConsumer;

  AdsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<AdsResponseModel> getAds({
    String? search,
    int? categoryId,
    num? minPrice,
    num? maxPrice,
    String? purpose,
    bool? isFeatured,
    int? page,
  }) async {
    final Map<String, dynamic> queryParameters = {};

    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }
    if (categoryId != null) {
      queryParameters['category_id'] = categoryId;
    }
    if (minPrice != null) {
      queryParameters['min_price'] = minPrice;
    }
    if (maxPrice != null) {
      queryParameters['max_price'] = maxPrice;
    }
    if (purpose != null) {
      queryParameters['purpose'] = purpose;
    }
    if (isFeatured != null) {
      queryParameters['is_featured'] = isFeatured;
    }
    if (page != null) {
      queryParameters['page'] = page;
    }

    final response = await apiConsumer.get(
      EndPoints.ads,
      queryParameters: queryParameters,
    );

    if (response is Map<String, dynamic>) {
      return compute(AdsResponseModel.parseAdsResponse, response);
    } else if (response is List) {
      // Handle legacy or unexpected list response
      final ads = await compute(AdsResponseModel.parseAdModelList, response);
      return AdsResponseModel(ads: ads);
    } else {
      return const AdsResponseModel(ads: []);
    }
  }

  @override
  Future<AdDetailsModel> getAdDetails(String id) async {
    final String url = '${EndPoints.ads}/$id';
    debugPrint('🚀 Fetching Ad Details: $url');
    final response = await apiConsumer.get(url);
    debugPrint('📥 Ad Details Response for $id: $response');

    if (response is Map && response['code'] != null) {
      final int code = int.tryParse(response['code'].toString()) ?? 200;
      if (code == 404) {
        debugPrint('❌ Ad $id not found (Business Error 404)');
        throw const NotFoundException();
      } else if (code != 200 && code != 201) {
        debugPrint('❌ Ad fetch failed with code $code: ${response['message']}');
        throw ServerException(response['message']?.toString() ?? 'Error $code');
      }
    }

    final data = (response is Map && response.containsKey('data'))
        ? response['data']
        : response;

    if (data == null || (data is List && data.isEmpty)) {
      debugPrint('❌ Ad $id response data is null or empty list');
      throw const NotFoundException();
    }

    try {
      if (data is! Map<String, dynamic>) {
        debugPrint('❌ Ad $id data is not a Map: $data');
        throw const UnknownException();
      }
      return AdDetailsModel.fromJson(data);
    } catch (e) {
      debugPrint('❌ AdDetailsModel.fromJson error for $id: $e');
      rethrow;
    }
  }

  @override
  Future<AdDetailsModel> getMyAdDetails(String id) async {
    final String myUrl = '${EndPoints.myAds}/$id';
    debugPrint('🚀 Fetching My Ad Details: $myUrl');

    final response = await apiConsumer.get(myUrl);
    debugPrint('📥 My Ad Details Response: $response');

    if (response is Map && response['code'] != null) {
      final int code = int.tryParse(response['code'].toString()) ?? 200;
      if (code == 404) {
        debugPrint('❌ My Ad $id not found (404)');
        throw const NotFoundException();
      }
      if (code != 200 && code != 201) {
        debugPrint(
          '❌ My Ad fetch failed with code $code: ${response['message']}',
        );
        throw ServerException(response['message']?.toString() ?? 'Error $code');
      }
    }

    final data = (response is Map && response.containsKey('data'))
        ? response['data']
        : response;

    if (data == null || data is! Map<String, dynamic>) {
      debugPrint('❌ My Ad $id data is null or invalid');
      throw const NotFoundException();
    }

    try {
      return AdDetailsModel.fromJson(data);
    } catch (e) {
      debugPrint('❌ AdDetailsModel.fromJson error for My Ad $id: $e');
      rethrow;
    }
  }

  @override
  Future<List<AdModel>> getMyAds() async {
    debugPrint('🚀 [START] getMyAds: ${EndPoints.myAds}');
    final response = await apiConsumer.get(EndPoints.myAds);
    debugPrint('📥 [RAW RESPONSE] My Ads List: $response');

    final List data;
    if (response is Map && response.containsKey('data')) {
      data = response['data'] as List;
    } else if (response is List) {
      data = response;
    } else {
      data = [];
    }

    try {
      return compute(AdsResponseModel.parseAdModelList, data);
    } catch (e) {
      debugPrint('❌ [PARSING ERROR] Failed to parse My Ads List: $e');
      rethrow;
    }
  }
}
