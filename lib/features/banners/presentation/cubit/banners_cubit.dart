import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/banner_repository.dart';
import 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  final BannerRepository repository;

  BannersCubit({required this.repository}) : super(BannersInitial());

  Future<void> getBanners() async {
    emit(BannersLoading());
    final result = await repository.getBanners();
    result.fold(
      (failure) => emit(BannersError(failure.message)),
      (banners) => emit(BannersLoaded(banners)),
    );
  }
}
