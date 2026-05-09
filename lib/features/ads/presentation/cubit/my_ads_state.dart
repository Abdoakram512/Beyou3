import 'package:equatable/equatable.dart';
import '../../domain/entities/ad_entity.dart';

sealed class MyAdsState extends Equatable {
  const MyAdsState();

  @override
  List<Object?> get props => [];
}

class MyAdsInitial extends MyAdsState {}

class MyAdsLoading extends MyAdsState {}

class MyAdsSuccess extends MyAdsState {
  final List<AdEntity> ads;

  const MyAdsSuccess(this.ads);

  @override
  List<Object?> get props => [ads];
}

class MyAdsError extends MyAdsState {
  final String message;

  const MyAdsError(this.message);

  @override
  List<Object?> get props => [message];
}
