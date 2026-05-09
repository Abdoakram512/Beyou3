import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/edit_ad_request_model.dart';
import '../../data/repositories/edit_ad_repository.dart';
import 'edit_ad_state.dart';

class EditAdCubit extends Cubit<EditAdState> {
  final EditAdRepository _repository;

  EditAdCubit(this._repository) : super(EditAdInitial());

  Future<void> editAd(EditAdRequestModel request) async {
    emit(EditAdLoading());
    final result = await _repository.editAd(request);
    result.fold(
      (failure) => emit(EditAdFailure(failure.message)),
      (ad) => emit(EditAdSuccess(ad)),
    );
  }
}
