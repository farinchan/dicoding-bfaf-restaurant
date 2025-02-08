import 'package:dicoding_submission_restaurant/presentation/pages/detail_page.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/bottom_nav.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/splash_screen.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static final GoRouter router = GoRouter(
    initialLocation: SplashScreen.name,
    routes: [
      GoRoute(
        path: SplashScreen.name,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: BottomNav.name,
        builder: (context, state) => const BottomNav(),
      ),
      GoRoute(
        path: '${DetailPage.name}/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailPage(id: id);
        },
      )
    ],
  );
}
