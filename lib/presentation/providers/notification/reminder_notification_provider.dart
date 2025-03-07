import 'dart:developer' as dev;
import 'dart:math';

import 'package:dicoding_submission_restaurant/core/services/workermanager_service.dart';
import 'package:dicoding_submission_restaurant/data/datasources/local/reminder_local_data_source.dart';
import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/notification/local_notification_provider.dart';
import 'package:flutter/material.dart';

class ReminderNotificationProvider extends ChangeNotifier {
  final ReminderLocalDataSource reminderLocalDataSource;
  final WorkmanagerService workmanagerService;
  final RemoteDatasource remoteDatasource;
  final LocalNotificationProvider localNotificationProvider;

  bool _isReminderOn = false;

  bool get isReminderOn => _isReminderOn;

  ReminderNotificationProvider(
    this.reminderLocalDataSource,
    this.workmanagerService,
    this.remoteDatasource,
    this.localNotificationProvider,
  ) {
    getReminderStatus();
  }

  Future<void> getReminderStatus() async {
    _isReminderOn = await reminderLocalDataSource.getReminderPreference();
    if (_isReminderOn) {
      await workmanagerService.runPeriodicTask();
    }
    notifyListeners();
  }

  Future<void> setReminderStatus(bool value) async {
    dev.log("Setting reminder status to $value");
    _isReminderOn = value;
    await reminderLocalDataSource.setReminderPreference(value);

    if (_isReminderOn) {
      try {
        await workmanagerService.runPeriodicTask();

        final randomRestaurant = await remoteDatasource.getListRestaurant();
        if (randomRestaurant.restaurants.isNotEmpty) {
          final randomRestaurantIndex =
              Random().nextInt(randomRestaurant.restaurants.length);
          final restaurant =
              randomRestaurant.restaurants[randomRestaurantIndex];

          localNotificationProvider
              .scheduleDailyElevenAMNotification(restaurant);
          dev.log("Daily Notification scheduled for ${restaurant.name}");
        } else {
          dev.log("No restaurant data found.");
        }
      } catch (e) {
        dev.log("Error: $e");
      }
    } else {
      await workmanagerService.cancelAllTask();
      await localNotificationProvider.cancelAllNotifications();
      dev.log("All tasks and notifications are canceled.");
    }

    notifyListeners();
  }
}
