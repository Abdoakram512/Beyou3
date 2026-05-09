import 'package:equatable/equatable.dart';
import 'ad_entity.dart';
import 'pagination_entity.dart';

class AdsResponseEntity extends Equatable {
  final List<AdEntity> ads;
  final PaginationEntity? pagination;

  const AdsResponseEntity({
    required this.ads,
    this.pagination,
  });

  @override
  List<Object?> get props => [ads, pagination];
}
