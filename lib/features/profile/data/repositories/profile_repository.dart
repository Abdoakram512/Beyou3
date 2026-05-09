import 'package:dartz/dartz.dart';

import '../../../../core/api/error_handler.dart';
import '../../../../core/error/failures.dart';
import '../models/profile_model.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';
import '../models/app_info_model.dart';
import '../models/faq_model.dart';

class ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  ProfileRepository({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  Future<Either<Failure, AppInfoModel>> getAboutUs() => safeCall(() async {
    final localData = await localDataSource.getAboutUs();
    if (localData != null) {
      // Fire and forget update in background
      remoteDataSource
          .getAboutUs()
          .then((remoteData) {
            localDataSource.cacheAboutUs(remoteData);
          })
          .catchError((_) {});
      return localData;
    }
    final remoteData = await remoteDataSource.getAboutUs();
    await localDataSource.cacheAboutUs(remoteData);
    return remoteData;
  });

  Future<Either<Failure, AppInfoModel>> getPrivacyPolicy() =>
      safeCall(() async {
        final localData = await localDataSource.getPrivacyPolicy();
        if (localData != null) {
          remoteDataSource
              .getPrivacyPolicy()
              .then((remoteData) {
                localDataSource.cachePrivacyPolicy(remoteData);
              })
              .catchError((_) {});
          return localData;
        }
        final remoteData = await remoteDataSource.getPrivacyPolicy();
        await localDataSource.cachePrivacyPolicy(remoteData);
        return remoteData;
      });

  Future<Either<Failure, AppInfoModel>> getTerms() => safeCall(() async {
    final localData = await localDataSource.getTerms();
    if (localData != null) {
      remoteDataSource
          .getTerms()
          .then((remoteData) {
            localDataSource.cacheTerms(remoteData);
          })
          .catchError((_) {});
      return localData;
    }
    final remoteData = await remoteDataSource.getTerms();
    await localDataSource.cacheTerms(remoteData);
    return remoteData;
  });

  Future<Either<Failure, List<FaqModel>>> getFaqs() => safeCall(() async {
    final localData = await localDataSource.getFaqs();
    if (localData != null) {
      remoteDataSource
          .getFaqs()
          .then((remoteData) {
            localDataSource.cacheFaqs(remoteData);
          })
          .catchError((_) {});
      return localData;
    }
    final remoteData = await remoteDataSource.getFaqs();
    await localDataSource.cacheFaqs(remoteData);
    return remoteData;
  });

  Future<Either<Failure, ProfileModel>> getProfile() =>
      safeCall(remoteDataSource.getProfile);

  Future<Either<Failure, ProfileModel>> updateProfile(
    Map<String, dynamic> data,
  ) => safeCall(() => remoteDataSource.updateProfile(data));

  Future<Either<Failure, Unit>> deleteAccount() => safeCall(() async {
    await remoteDataSource.deleteAccount();
    return unit;
  });

  Future<Either<Failure, Unit>> sendContactMessage({
    required String subject,
    required String message,
  }) => safeCall(() async {
    await remoteDataSource.sendContactMessage(subject, message);
    return unit;
  });
}
