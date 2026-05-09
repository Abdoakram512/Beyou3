import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/brand_model.dart';

abstract class BrandsRemoteDataSource {
  Future<List<BrandModel>> getBrands();
}

class BrandsRemoteDataSourceImpl implements BrandsRemoteDataSource {
  final ApiConsumer _apiConsumer;

  BrandsRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<List<BrandModel>> getBrands() async {
    final response = await _apiConsumer.get(EndPoints.brands);
    return List<BrandModel>.from(
      response['data'].map((x) => BrandModel.fromJson(x)),
    );
  }
}
