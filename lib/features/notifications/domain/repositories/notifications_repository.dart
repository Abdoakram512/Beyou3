import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/notifications_response_model.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificationsResponseModel>> getNotifications({
    int page = 1,
  });
}
