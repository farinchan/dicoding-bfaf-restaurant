import 'package:dicoding_submission_restaurant/core/routes/app_route.dart';
import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/detail/restaurant_detail_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/detail/restaurant_review_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/home/restaurant_list_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/main/index_nav_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/search/restaurant_search_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/theme/theme_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/styles/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => IndexNavProvider()),
        Provider(create: (context) => RemoteDatasource()),
        ChangeNotifierProvider(
            create: (context) =>
                RestaurantListProvider(context.read<RemoteDatasource>())),
        ChangeNotifierProvider(
            create: (context) =>
                RestaurantSearchProvider(context.read<RemoteDatasource>())),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(
            create: (context) =>
                RestaurantDetailProvider(context.read<RemoteDatasource>())),
        ChangeNotifierProvider(
            create: (context) =>
                RestaurantReviewProvider(context.read<RemoteDatasource>()))
      ],
      child: const MainApp(),
    );
  }
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
