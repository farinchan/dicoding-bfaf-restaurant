import 'package:dicoding_submission_restaurant/core/routes/app_route.dart';
import 'package:dicoding_submission_restaurant/core/services/http_service.dart';
import 'package:dicoding_submission_restaurant/core/services/local_notification_service.dart';
import 'package:dicoding_submission_restaurant/core/services/sqflite_service.dart';
import 'package:dicoding_submission_restaurant/core/services/workermanager_service.dart';
import 'package:dicoding_submission_restaurant/data/datasources/local/reminder_local_data_source.dart';
import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/bottom_nav.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/detail_page.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/detail/restaurant_detail_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/detail/restaurant_review_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/favorite/restaurant_favorite_list_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/home/restaurant_list_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/main/index_nav_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/notification/local_notification_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/notification/payload_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/notification/reminder_notification_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/search/restaurant_search_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/theme/theme_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/styles/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  String? route = BottomNav.route;
  String? payload;
  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    final notificationResponse =
        notificationAppLaunchDetails!.notificationResponse;
    route = DetailPage.route;
    payload = notificationResponse?.payload;
  }

  runApp(MultiProvider(
    providers: [
      Provider<SqliteService>(create: (_) => SqliteService()),
      ChangeNotifierProvider(create: (context) => IndexNavProvider()),
      Provider(create: (context) => RemoteDatasource()),
      Provider(create: (context) => HttpService()),
      Provider(
        create: (context) => LocalNotificationService(
          context.read<HttpService>(),
        )
          ..init()
          ..configureLocalTimeZone(),
      ),
      Provider(create: (context) => ReminderLocalDataSource()),
      ChangeNotifierProvider(
        create: (context) => PayloadProvider(
          payload: payload,
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => LocalNotificationProvider(
          context.read<LocalNotificationService>()..requestPermissions(),
        ),
      ),
      Provider(create: (context) => WorkmanagerService()..init()),
      ChangeNotifierProvider(
        create: (context) => RestaurantListProvider(
          context.read<RemoteDatasource>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => RestaurantSearchProvider(
          context.read<RemoteDatasource>(),
        ),
      ),
      ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ChangeNotifierProvider(
        create: (context) => RestaurantDetailProvider(
          context.read<RemoteDatasource>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => RestaurantReviewProvider(
          context.read<RemoteDatasource>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => RestaurantFavoriteListProvider(
          context.read<SqliteService>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => ReminderNotificationProvider(
          context.read<ReminderLocalDataSource>(),
          context.read<WorkmanagerService>(),
          context.read<RemoteDatasource>(),
          context.read<LocalNotificationProvider>(),
        ),
      ),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Provider.of<ThemeProvider>(context).isDark
          ? ThemeMode.light
          : ThemeMode.dark,
      routerConfig: AppRoute.router,
    );
  }
}
