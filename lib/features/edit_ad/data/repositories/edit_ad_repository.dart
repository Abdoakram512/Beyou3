import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../../../ads/data/models/ad_model.dart';
import '../datasources/edit_ad_remote_data_source.dart';
import '../models/edit_ad_request_model.dart';

class EditAdRepository {
  final EditAdRemoteDataSource remoteDataSource;

  EditAdRepository(this.remoteDataSource);

  Future<Either<Failure, AdModel>> editAd(EditAdRequestModel request) async {
    return await safeCall(() => remoteDataSource.editAd(request));
  }
}
