import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ads_repository.dart';
import 'featured_ads_state.dart';

class FeaturedAdsCubit extends Cubit<FeaturedAdsState> {
  final AdsRepository adsRepository;

  FeaturedAdsCubit({required this.adsRepository}) : super(FeaturedAdsInitial());

  Future<void> getFeaturedAds() async {
    emit(FeaturedAdsLoading());
    try {
      final result = await adsRepository.getAds(isFeatured: true);
      result.fold((failure) => emit(FeaturedAdsError(failure.message)), (response) {
        emit(FeaturedAdsLoaded(response.ads));
      });
    } catch (e) {
      emit(const FeaturedAdsError("Failed to load featured ads"));
    }
  }
}
