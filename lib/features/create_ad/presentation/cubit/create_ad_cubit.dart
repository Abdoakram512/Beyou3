import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/create_ad_request_model.dart';
import '../../domain/repositories/ad_repository.dart';
import 'create_ad_state.dart';

class CreateAdCubit extends Cubit<CreateAdState> {
  final AdRepository _adRepository;

  CreateAdCubit(this._adRepository) : super(const CreateAdState());

  static CreateAdCubit get(BuildContext context) =>
      BlocProvider.of<CreateAdCubit>(context);

  void setStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  void saveStep1Data({
    required int categoryId,
    required String title,
    required String description,
  }) {
    emit(
      state.copyWith(
        categoryId: categoryId,
        title: title,
        description: description,
      ),
    );
    nextStep();
  }

  void saveStep2Data({
    required String price,
    String? address,
    String? area,
    String? lat,
    String? lng,
    String? purpose,
    int? brandId,
  }) {
    emit(
      state.copyWith(
        price: price,
        address: address,
        area: area,
        lat: lat,
        lng: lng,
        purpose: purpose,
        brandId: brandId,
      ),
    );
    nextStep();
  }

  void updateImages({File? mainImage, required List<File> extraImages}) {
    emit(state.copyWith(mainImage: mainImage, extraImages: extraImages));
  }

  void nextStep() {
    if (state.currentStep < 2) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  Future<void> createAd() async {
    if (state.status == CreateAdStatus.loading) return;

    if (state.mainImage == null) {
      emit(
        state.copyWith(
          status: CreateAdStatus.failure,
          errorMessage: tr('add_main_image'),
        ),
      );
      emit(
        state.copyWith(status: CreateAdStatus.initial),
      ); // reset status so user can retry
      return;
    }

    if (state.categoryId == null) {
      emit(
        state.copyWith(
          status: CreateAdStatus.failure,
          errorMessage: tr('please_choose_category'),
        ),
      );
      emit(state.copyWith(status: CreateAdStatus.initial));
      return;
    }

    emit(state.copyWith(status: CreateAdStatus.loading, clearError: true));

    final request = CreateAdRequestModel(
      categoryId: state.categoryId!,
      title: state.title,
      description: state.description,
      price: state.price,
      mainImage: state.mainImage!,
      extraImages: state.extraImages,
      address: state.address?.isNotEmpty == true ? state.address : null,
      area: state.area?.isNotEmpty == true ? state.area : null,
      lat: state.lat?.isNotEmpty == true ? state.lat : null,
      lng: state.lng?.isNotEmpty == true ? state.lng : null,
      purpose: state.purpose,
      brandId: state.brandId,
    );

    final result = await _adRepository.createAd(request);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: CreateAdStatus.failure,
            errorMessage: failure.message,
          ),
        );
        emit(state.copyWith(status: CreateAdStatus.initial)); // allow retry
      },
      (ad) {
        emit(state.copyWith(status: CreateAdStatus.success));
      },
    );
  }

  void reset() {
    emit(const CreateAdState());
  }
}
