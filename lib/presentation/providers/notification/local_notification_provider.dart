import 'package:dicoding_submission_restaurant/core/services/local_notification_service.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService);

  int _notificationId = 0;
  bool? _permission = false;
  bool? get permission => _permission;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  void scheduleDailyElevenAMNotification(Restaurant restaurant) {
    _notificationId += 1;
    flutterNotificationService.scheduleDailyElevenAMNotification(
      id: _notificationId,
      channelId: "3",
      channelName: "Daily Notification",
      restaurant: restaurant,
    );
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    pendingNotificationRequests =
        await flutterNotificationService.pendingNotificationRequests();
    notifyListeners();
  }

  Future<void> cancelAllNotifications() async {
    await flutterNotificationService.cancelAllNotifications();
  }

  Future<void> cancelNotification(int id) async {
    await flutterNotificationService.cancelNotification(id);
  }
}
