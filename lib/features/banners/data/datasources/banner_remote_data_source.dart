import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';

abstract class BannerRemoteDataSource {
  Future<List<String>> getBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final ApiConsumer apiConsumer;

  BannerRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<String>> getBanners() async {
    final response = await apiConsumer.get(EndPoints.banners);

    final List data;
    if (response is Map && response.containsKey('data')) {
      data = response['data'] as List;
    } else if (response is List) {
      data = response;
    } else {
      data = [];
    }

    return data.map((item) => item['banner'] as String).toList();
  }
}
