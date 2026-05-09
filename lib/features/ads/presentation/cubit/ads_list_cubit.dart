import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ads_repository.dart';
import 'ads_list_state.dart';

class AdsListCubit extends Cubit<AdsListState> {
  final AdsRepository adsRepository;

  AdsListCubit({required this.adsRepository}) : super(AdsListInitial());

  Future<void> getAds({
    String? search,
    int? categoryId,
    num? minPrice,
    num? maxPrice,
    String? purpose,
    bool? isFeatured,
    int page = 1,
  }) async {
    if (page == 1) {
      emit(AdsListLoading());
    } else if (state is AdsListLoaded) {
      emit((state as AdsListLoaded).copyWith(isLoadingMore: true));
    }

    final result = await adsRepository.getAds(
      search: search,
      categoryId: categoryId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      purpose: purpose,
      isFeatured: isFeatured,
      page: page,
    );

    result.fold(
      (failure) => emit(AdsListError(failure.message)),
      (response) {
        if (page == 1) {
          emit(AdsListLoaded(
            ads: response.ads,
            pagination: response.pagination,
          ));
        } else if (state is AdsListLoaded) {
          final currentState = state as AdsListLoaded;
          emit(AdsListLoaded(
            ads: [...currentState.ads, ...response.ads],
            pagination: response.pagination,
            isLoadingMore: false,
          ));
        }
      },
    );
  }

  Future<void> loadMoreAds({
    String? search,
    int? categoryId,
    num? minPrice,
    num? maxPrice,
    String? purpose,
    bool? isFeatured,
  }) async {
    if (state is AdsListLoaded) {
      final currentState = state as AdsListLoaded;
      
      // Check if there are more pages
      if (currentState.pagination != null &&
          currentState.currentPage < currentState.totalPages &&
          !currentState.isLoadingMore) {
        
        await getAds(
          search: search,
          categoryId: categoryId,
          minPrice: minPrice,
          maxPrice: maxPrice,
          purpose: purpose,
          isFeatured: isFeatured,
          page: currentState.currentPage + 1,
        );
      }
    }
  }
}

extension AdsListLoadedX on AdsListLoaded {
  int get currentPage => pagination?.currentPage ?? 1;
  int get totalPages => pagination?.pagesCount ?? 1;
}
