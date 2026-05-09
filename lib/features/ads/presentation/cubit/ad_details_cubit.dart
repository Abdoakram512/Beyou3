import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ads_repository.dart';
import 'ad_details_state.dart';

class AdDetailsCubit extends Cubit<AdDetailsState> {
  final AdsRepository repository;

  AdDetailsCubit({required this.repository}) : super(AdDetailsInitial());

  Future<void> getAdDetails(String id) async {
    emit(AdDetailsLoading());
    final result = await repository.getAdDetails(id);
    result.fold(
      (failure) => emit(AdDetailsError(failure.message)),
      (adDetails) => emit(AdDetailsLoaded(adDetails)),
    );
  }

  Future<void> getMyAdDetails(String id) async {
    emit(AdDetailsLoading());
    final result = await repository.getMyAdDetails(id);
    result.fold(
      (failure) => emit(AdDetailsError(failure.message)),
      (adDetails) => emit(AdDetailsLoaded(adDetails)),
    );
  }
}
