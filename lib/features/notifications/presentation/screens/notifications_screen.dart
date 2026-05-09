import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/common/custom_app_bar.dart';
import '../../../../core/widgets/feedback/app_error_state.dart';
import '../../../../core/widgets/feedback/app_loading_indicator.dart';
import '../../../../core/widgets/feedback/app_refresh_indicator.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<NotificationsCubit>().getNotifications(isRefresh: true);
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NotificationsCubit>().getNotifications();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: tr('notifications'),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const AppLoadingIndicator();
          } else if (state is NotificationsLoaded) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Text(
                  tr('no_notifications'),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            }

            return AppRefreshIndicator(
              onRefresh: () => context.read<NotificationsCubit>().getNotifications(isRefresh: true),
              child: ListView.builder(
                controller: _scrollController,
                cacheExtent: 300,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                itemCount: state.hasReachedMax ? notifications.length : notifications.length + 1,
                itemBuilder: (context, index) {
                  if (index >= notifications.length) {
                    return const AppLoadingIndicator();
                  }
                  return RepaintBoundary(
                    child: NotificationItem(notification: notifications[index]),
                  );
                },
              ),
            );
          } else if (state is NotificationsError) {
            return AppErrorState(
              message: state.message,
              onRetry: () => context.read<NotificationsCubit>().getNotifications(isRefresh: true),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
