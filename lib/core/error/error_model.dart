import 'package:easy_localization/easy_localization.dart';

class ErrorModel {
  final String errorMessage;
  final int? code;
  final Map<String, dynamic>? data;

  ErrorModel({required this.errorMessage, this.code, this.data});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    String? message;

    if (json['message'] != null) {
      message = json['message'].toString();
    } else if (json['error'] != null) {
      message = json['error'].toString();
    } else if (json['errors'] != null && json['errors'] is Map) {
      final errors = json['errors'] as Map<String, dynamic>;
      final allMessages = <String>[];
      errors.forEach((key, value) {
        if (value is List) {
          allMessages.addAll(value.map((e) => e.toString()));
        } else {
          allMessages.add(value.toString());
        }
      });
      message = allMessages.join(', ');
    } else if (json['data'] != null && json['data'] is Map) {
      final data = json['data'] as Map<String, dynamic>;
      // Check if it's a map of field errors (e.g. {"field": ["error"]})
      if (data.values.any((v) => v is List)) {
        final allMessages = <String>[];
        data.forEach((key, value) {
          if (value is List) {
            allMessages.addAll(value.map((e) => e.toString()));
          } else if (value is String) {
            allMessages.add(value);
          }
        });
        if (allMessages.isNotEmpty) {
          message = allMessages.join(', ');
        }
      }

      if (message == null && data['message'] != null) {
        message = data['message'].toString();
      }
    }

    return ErrorModel(
      errorMessage: message ?? tr('unknown_error'),
      code: json['code'] is int ? json['code'] as int : null,
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : null,
    );
  }
}
