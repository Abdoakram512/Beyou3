import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../ads/data/models/ad_model.dart';
import '../models/edit_ad_request_model.dart';

abstract class EditAdRemoteDataSource {
  Future<AdModel> editAd(EditAdRequestModel request);
}

class EditAdRemoteDataSourceImpl implements EditAdRemoteDataSource {
  final ApiConsumer _apiConsumer;

  EditAdRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<AdModel> editAd(EditAdRequestModel request) async {
    final response = await _apiConsumer.post(
      '${EndPoints.updateAds}/${request.adId}',
      data: await request.toFormData(),
      isFormData: true,
    );
    return AdModel.fromJson(response['data']);
  }
}
