import 'package:equatable/equatable.dart';
import '../../../ads/data/models/ad_model.dart';

abstract class EditAdState extends Equatable {
  const EditAdState();

  @override
  List<Object?> get props => [];
}

class EditAdInitial extends EditAdState {}

class EditAdLoading extends EditAdState {}

class EditAdSuccess extends EditAdState {
  final AdModel ad;
  const EditAdSuccess(this.ad);

  @override
  List<Object?> get props => [ad];
}

class EditAdFailure extends EditAdState {
  final String message;
  const EditAdFailure(this.message);

  @override
  List<Object?> get props => [message];
}
