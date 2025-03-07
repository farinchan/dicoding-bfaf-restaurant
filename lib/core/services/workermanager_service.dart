import 'dart:math';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:dicoding_submission_restaurant/core/constants/my_workmanager.dart';
import 'package:dicoding_submission_restaurant/core/services/http_service.dart';
import 'package:dicoding_submission_restaurant/core/services/local_notification_service.dart';
import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta')); // Sesuaikan dengan zona waktu

      final localNotificationService = LocalNotificationService(HttpService());
      final remoteDatasource = RemoteDatasource();


      final randomRestaurant = await remoteDatasource.getListRestaurant();
      if (randomRestaurant.restaurants.isNotEmpty) {
        final randomRestaurantIndex =
            Random().nextInt(randomRestaurant.restaurants.length);
        final restaurant = randomRestaurant.restaurants[randomRestaurantIndex];

        await localNotificationService.scheduleDailyElevenAMNotification(
          id: 1,
          channelId: "daily_notification",
          channelName: "Daily Notification",
          restaurant: restaurant,
        );
        print("Daily Notification scheduled for ${restaurant.name}");
      } else {
        print("No restaurant data found.");
      }

      return Future.value(true);
    } catch (e) {
      print("Error: $e");
      return Future.value(false);
    }
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService({Workmanager? workmanager})
      : _workmanager = workmanager ?? Workmanager();

  Future<void> init() async {
    print("WorkManagerService: Initializing WorkManager...");
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  Future<void> runOneOffTask() async {
    print("WorkManagerService: Running one-off task...");
    await _workmanager.registerOneOffTask(
      MyWorkmanager.oneOff.uniqueName,
      MyWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": "This is a valid payload from one-off task workmanager",
      },
    );
  }

  Future<void> runPeriodicTask() async {
    print("WorkManagerService: Running periodic task...");

    // Hindari duplikasi tugas
    await cancelAllTask();

    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(minutes: 15), // Minimal 15 menit di Android
      initialDelay: Duration.zero,
      existingWorkPolicy: ExistingWorkPolicy.replace, // Hapus tugas sebelumnya
      inputData: {
        "data": "This is a valid payload from periodic task workmanager",
      },
    );
    print("WorkManagerService: Periodic task is running...");
  }

  Future<void> cancelAllTask() async {
    print("WorkManagerService: Canceling all tasks...");
    await _workmanager.cancelAll();
  }
}
