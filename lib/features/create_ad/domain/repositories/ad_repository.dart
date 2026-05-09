import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../ads/data/models/ad_model.dart';
import '../../data/models/brand_model.dart';
import '../../data/models/create_ad_request_model.dart';

abstract class AdRepository {
  Future<Either<Failure, AdModel>> createAd(CreateAdRequestModel request);
  Future<Either<Failure, List<BrandModel>>> getBrands();
}
