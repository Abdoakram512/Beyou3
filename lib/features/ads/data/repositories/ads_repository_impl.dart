import 'package:dartz/dartz.dart';
import '../../../../core/api/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ad_details_entity.dart';
import '../../domain/entities/ad_entity.dart';
import '../../domain/entities/ads_response_entity.dart';
import '../../domain/repositories/ads_repository.dart';
import '../datasources/ads_remote_data_source.dart';

class AdsRepositoryImpl implements AdsRepository {
  final AdsRemoteDataSource remoteDataSource;

  AdsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AdsResponseEntity>> getAds({
    String? search,
    int? categoryId,
    num? minPrice,
    num? maxPrice,
    String? purpose,
    bool? isFeatured,
    int? page,
  }) => safeCall(
    () => remoteDataSource.getAds(
      search: search,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      purpose: purpose,
      isFeatured: isFeatured,
      page: page,
    ),
  );

  @override
  Future<Either<Failure, AdDetailsEntity>> getAdDetails(String id) =>
      safeCall(() => remoteDataSource.getAdDetails(id));

  @override
  Future<Either<Failure, AdDetailsEntity>> getMyAdDetails(String id) =>
      safeCall(() => remoteDataSource.getMyAdDetails(id));

  @override
  Future<Either<Failure, List<AdEntity>>> getMyAds() =>
      safeCall(() => remoteDataSource.getMyAds());
}
