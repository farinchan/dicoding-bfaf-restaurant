import 'package:dicoding_submission_restaurant/presentation/pages/detail_page.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/bottom_nav.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/setting_page.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    initialLocation: SplashScreen.route,
    routes: [
      GoRoute(
        path: SplashScreen.route,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: BottomNav.route,
        builder: (context, state) => const BottomNav(),
        routes: [
          GoRoute(
            path: '${DetailPage.route}/:id',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return DetailPage(id: id);
            },
          ),
          GoRoute(
            path: SettingPage.route,
            builder: (context, state) {
              return SettingPage();
            },
          )
        ],
      ),
    ],
  );
}
