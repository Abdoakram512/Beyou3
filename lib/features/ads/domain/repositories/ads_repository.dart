import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/ad_details_entity.dart';
import '../entities/ad_entity.dart';
import '../entities/ads_response_entity.dart';

abstract class AdsRepository {
  Future<Either<Failure, AdsResponseEntity>> getAds({
    String? search,
    int? categoryId,
    num? minPrice,
    num? maxPrice,
    String? purpose,
    bool? isFeatured,
    int? page,
  });

  Future<Either<Failure, AdDetailsEntity>> getAdDetails(String id);
  Future<Either<Failure, AdDetailsEntity>> getMyAdDetails(String id);
  Future<Either<Failure, List<AdEntity>>> getMyAds();
}
