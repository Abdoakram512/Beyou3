import 'package:dartz/dartz.dart';
import '../../../../core/api/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../ads/data/models/ad_model.dart';
import '../datasources/ad_remote_data_source.dart';
import '../datasources/brands_remote_data_source.dart';
import '../models/brand_model.dart';
import '../models/create_ad_request_model.dart';
import '../../domain/repositories/ad_repository.dart';

class AdRepositoryImpl implements AdRepository {
  final AdRemoteDataSource _adRemoteDataSource;
  final BrandsRemoteDataSource _brandsRemoteDataSource;

  AdRepositoryImpl(this._adRemoteDataSource, this._brandsRemoteDataSource);

  @override
  Future<Either<Failure, AdModel>> createAd(
    CreateAdRequestModel request,
  ) async {
    return safeCall(() => _adRemoteDataSource.createAd(request));
  }

  @override
  Future<Either<Failure, List<BrandModel>>> getBrands() async {
    return safeCall(() => _brandsRemoteDataSource.getBrands());
  }
}
