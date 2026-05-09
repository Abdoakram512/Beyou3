import 'package:beyou3/features/ads/domain/entities/ad_entity.dart';
import 'package:equatable/equatable.dart';

sealed class FeaturedAdsState extends Equatable {
  const FeaturedAdsState();

  @override
  List<Object?> get props => [];
}

class FeaturedAdsInitial extends FeaturedAdsState {}

class FeaturedAdsLoading extends FeaturedAdsState {}

class FeaturedAdsLoaded extends FeaturedAdsState {
  final List<AdEntity> ads;
  const FeaturedAdsLoaded(this.ads);

  @override
  List<Object?> get props => [ads];
}

class FeaturedAdsError extends FeaturedAdsState {
  final String message;
  const FeaturedAdsError(this.message);

  @override
  List<Object?> get props => [message];
}
