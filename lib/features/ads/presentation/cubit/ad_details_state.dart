import 'package:equatable/equatable.dart';
import '../../domain/entities/ad_details_entity.dart';

sealed class AdDetailsState extends Equatable {
  const AdDetailsState();

  @override
  List<Object?> get props => [];
}

class AdDetailsInitial extends AdDetailsState {}

class AdDetailsLoading extends AdDetailsState {}

class AdDetailsLoaded extends AdDetailsState {
  final AdDetailsEntity adDetails;

  const AdDetailsLoaded(this.adDetails);

  @override
  List<Object?> get props => [adDetails];
}

class AdDetailsError extends AdDetailsState {
  final String message;

  const AdDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
