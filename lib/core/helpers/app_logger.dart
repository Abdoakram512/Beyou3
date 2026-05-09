import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppLogger {
  /// Logs a message only in debug mode using dart:developer log
  static void log(
    String message, {
    String? name,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      dev.log(
        message,
        name: name ?? 'AppLogger',
        error: error,
        stackTrace: stackTrace,
        time: DateTime.now(),
      );
    }
  }

  /// Logs a simple message to the console in debug mode
  static void debug(Object? message) {
    if (kDebugMode) {
      debugPrint(message?.toString());
    }
  }

  /// Logs an error message and reports to Crashlytics in production
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      dev.log(
        '❌ $message',
        name: 'AppError',
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      // In production, report to Crashlytics
      FirebaseCrashlytics.instance.recordError(
        error ?? message,
        stackTrace,
        reason: message,
      );
    }
  }
}
