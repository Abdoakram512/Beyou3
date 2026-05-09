import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/notifications_repository.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository repository;

  NotificationsCubit({required this.repository}) : super(NotificationsInitial());

  int _currentPage = 1;

  Future<void> getNotifications({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      emit(NotificationsLoading());
    } else {
      if (state is NotificationsLoaded && (state as NotificationsLoaded).hasReachedMax) return;
      
      if (state is NotificationsLoaded) {
        emit(NotificationsPaginationLoading(
          notifications: (state as NotificationsLoaded).notifications,
          hasReachedMax: (state as NotificationsLoaded).hasReachedMax,
          currentPage: (state as NotificationsLoaded).currentPage,
        ));
      } else {
        emit(NotificationsLoading());
      }
    }

    final result = await repository.getNotifications(page: _currentPage);

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (response) {
        final notifications = response.data;
        final hasReachedMax = response.pagination == null || 
                             response.pagination!.currentPage >= response.pagination!.pagesCount;
        
        if (isRefresh || state is! NotificationsLoaded) {
          emit(NotificationsLoaded(
            notifications: notifications,
            hasReachedMax: hasReachedMax,
            currentPage: _currentPage,
          ));
        } else {
          final currentNotifications = (state as NotificationsLoaded).notifications;
          emit(NotificationsLoaded(
            notifications: currentNotifications + notifications,
            hasReachedMax: hasReachedMax,
            currentPage: _currentPage,
          ));
        }
        
        if (!hasReachedMax) {
          _currentPage++;
        }
      },
    );
  }
}
