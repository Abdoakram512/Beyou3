import 'package:dartz/dartz.dart';
import '../../../../core/api/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';
import '../models/notifications_response_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, NotificationsResponseModel>> getNotifications({int page = 1}) =>
      safeCall(() => remoteDataSource.getNotifications(page: page));
}
