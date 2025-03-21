import 'dart:async';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final List<String> _notifications = [];
  final _notificationController = StreamController<String>.broadcast();

  Stream<String> get notificationStream => _notificationController.stream;
  List<String> get notifications => List.unmodifiable(_notifications);

  void addNotification(String message) {
    _notifications.insert(0, message);
    // Keep only the last 100 notifications
    if (_notifications.length > 100) {
      _notifications.removeLast();
    }
    _notificationController.add(message);
  }

  void dispose() {
    _notificationController.close();
  }
}
