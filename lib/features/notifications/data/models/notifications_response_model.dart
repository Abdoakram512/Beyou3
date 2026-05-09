import 'notification_model.dart';
import '../../../ads/data/models/pagination_model.dart';

class NotificationsResponseModel {
  final int code;
  final String message;
  final List<NotificationModel> data;
  final PaginationModel? pagination;

  NotificationsResponseModel({
    required this.code,
    required this.message,
    required this.data,
    this.pagination,
  });

  factory NotificationsResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationsResponseModel(
      code: json['code'] is int
          ? json['code']
          : int.tryParse(json['code']?.toString() ?? '0') ?? 0,
      message: json['message']?.toString() ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => NotificationModel.fromJson(e))
          .toList(),
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'])
          : null,
    );
  }
}
