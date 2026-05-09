import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../models/notifications_response_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications({int page = 1});
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final ApiConsumer apiConsumer;

  NotificationsRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<NotificationsResponseModel> getNotifications({int page = 1}) async {
    final response = await apiConsumer.get(
      EndPoints.notifications,
      queryParameters: {'page': page},
    );

    return NotificationsResponseModel.fromJson(response as Map<String, dynamic>);
  }
}
