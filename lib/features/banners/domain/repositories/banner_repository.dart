import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class BannerRepository {
  Future<Either<Failure, List<String>>> getBanners();
}
