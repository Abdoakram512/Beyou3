import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/banner_repository.dart';
import '../datasources/banner_remote_data_source.dart';

class BannerRepositoryImpl implements BannerRepository {
  final BannerRemoteDataSource remoteDataSource;

  BannerRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<String>>> getBanners() =>
      safeCall(remoteDataSource.getBanners);
}
