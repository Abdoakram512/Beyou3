import 'package:beyou3/features/notifications/domain/entities/notification_entity.dart';
import 'package:equatable/equatable.dart';

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationEntity> notifications;
  final bool hasReachedMax;
  final int currentPage;

  const NotificationsLoaded({
    required this.notifications,
    this.hasReachedMax = false,
    this.currentPage = 1,
  });

  @override
  List<Object?> get props => [notifications, hasReachedMax, currentPage];

  NotificationsLoaded copyWith({
    List<NotificationEntity>? notifications,
    bool? hasReachedMax,
    int? currentPage,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class NotificationsPaginationLoading extends NotificationsLoaded {
  const NotificationsPaginationLoading({
    required super.notifications,
    required super.hasReachedMax,
    required super.currentPage,
  });
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
