import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ads_repository.dart';
import 'my_ads_state.dart';

class MyAdsCubit extends Cubit<MyAdsState> {
  final AdsRepository adsRepository;

  MyAdsCubit({required this.adsRepository}) : super(MyAdsInitial());

  Future<void> getMyAds() async {
    emit(MyAdsLoading());
    final result = await adsRepository.getMyAds();

    result.fold(
      (failure) => emit(MyAdsError(failure.message)),
      (ads) => emit(MyAdsSuccess(ads)),
    );
  }
}
