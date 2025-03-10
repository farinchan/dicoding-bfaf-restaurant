import 'package:dicoding_submission_restaurant/presentation/pages/favorite_page.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/home_page.dart';
import 'package:dicoding_submission_restaurant/presentation/pages/search_page.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/main/index_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNav extends StatelessWidget {
  static const String route = '/';
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(builder: (context, value, child) {
        return switch (value.indexBottomNavbar) {
          0 => const HomePage(),
          1 => const SearchPage(),
          2 => const FavoritePage(),
          _ => const HomePage(), // default case
        };
      }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: context.watch<IndexNavProvider>().indexBottomNavbar,
          onTap: (index) =>
              context.read<IndexNavProvider>().setIndexbottomNavbar = index,
          selectedLabelStyle:
              TextStyle(color: Theme.of(context).colorScheme.primary),
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                ),
                label: 'Home',
                tooltip: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                ),
                label: 'Search',
                tooltip: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                ),
                label: 'Favorite',
                tooltip: 'Favorite'),
          ]),
    );
  }
}
