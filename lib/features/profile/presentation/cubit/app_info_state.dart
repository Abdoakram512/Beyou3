import 'package:equatable/equatable.dart';
import '../../data/models/app_info_model.dart';
import '../../data/models/faq_model.dart';

sealed class AppInfoState extends Equatable {
  const AppInfoState();

  @override
  List<Object?> get props => [];
}

class AppInfoInitial extends AppInfoState {}

class AppInfoLoading extends AppInfoState {}

class AppInfoLoaded extends AppInfoState {
  final AppInfoModel data;
  const AppInfoLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class FaqLoaded extends AppInfoState {
  final List<FaqModel> faqs;
  const FaqLoaded(this.faqs);

  @override
  List<Object?> get props => [faqs];
}

class AppInfoError extends AppInfoState {
  final String message;
  const AppInfoError(this.message);

  @override
  List<Object?> get props => [message];
}
