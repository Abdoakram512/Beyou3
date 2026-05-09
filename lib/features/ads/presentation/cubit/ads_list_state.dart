import 'package:beyou3/features/ads/domain/entities/ad_entity.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/pagination_entity.dart';

sealed class AdsListState extends Equatable {
  const AdsListState();

  @override
  List<Object?> get props => [];
}

class AdsListInitial extends AdsListState {}

class AdsListLoading extends AdsListState {}

class AdsListLoaded extends AdsListState {
  final List<AdEntity> ads;
  final PaginationEntity? pagination;
  final bool isLoadingMore;

  const AdsListLoaded({
    required this.ads,
    this.pagination,
    this.isLoadingMore = false,
  });

  AdsListLoaded copyWith({
    List<AdEntity>? ads,
    PaginationEntity? pagination,
    bool? isLoadingMore,
  }) {
    return AdsListLoaded(
      ads: ads ?? this.ads,
      pagination: pagination ?? this.pagination,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [ads, pagination, isLoadingMore];
}

class AdsListError extends AdsListState {
  final String message;

  const AdsListError(this.message);

  @override
  List<Object?> get props => [message];
}
