import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final int id;
  final String title;
  final String body;
  final String createdAt;
  final bool isRead; // ✅ Fix 2.2: Read/Unread state

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    this.isRead = false,
  });

  @override
  List<Object?> get props => [id, title, body, createdAt, isRead];
}
