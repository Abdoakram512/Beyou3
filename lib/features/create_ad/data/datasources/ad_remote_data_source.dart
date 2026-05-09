import '../../../ads/data/models/ad_model.dart';
import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/create_ad_request_model.dart';

abstract class AdRemoteDataSource {
  Future<AdModel> createAd(CreateAdRequestModel request);
}

class AdRemoteDataSourceImpl implements AdRemoteDataSource {
  final ApiConsumer _apiConsumer;

  AdRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<AdModel> createAd(CreateAdRequestModel request) async {
    final response = await _apiConsumer.post(
      EndPoints.ads,
      data: await request.toMap(),
      isFormData: true,
    );
    return AdModel.fromJson(response['data']);
  }
}
