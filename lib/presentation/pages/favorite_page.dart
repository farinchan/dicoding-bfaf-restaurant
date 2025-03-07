import 'package:dicoding_submission_restaurant/core/utils/restaurant_favorite_state.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/favorite/restaurant_favorite_list_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/theme/theme_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/widgets/restaurant_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantFavoriteListProvider>().loadFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'Favorite Resto',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Consumer<ThemeProvider>(
                builder: (context, value, child) => GestureDetector(
                  onTap: () => value.setTheme(),
                  child: value.isDark
                      ? Icon(
                          Icons.nightlight_round,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.0,
                        )
                      : Icon(
                          Icons.wb_sunny,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24.0,
                        ),
                ),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Consumer<RestaurantFavoriteListProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    RestaurantFavoriteLoading() => Center(
                          child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      )),
                    RestaurantFavoriteSuccess() => ListView.builder(
                        itemCount: value.Restaurantfavorites.length,
                        itemBuilder: (context, index) {
                          final restaurant = value.Restaurantfavorites[index];
                          return Hero(
                            tag: restaurant.pictureId,
                            child: RestaurantItem(
                                restaurant: Restaurant(
                                    id: value.Restaurantfavorites[index].id,
                                    name: value.Restaurantfavorites[index].name,
                                    description: value
                                        .Restaurantfavorites[index].description,
                                    pictureId: value
                                        .Restaurantfavorites[index].pictureId,
                                    city: value.Restaurantfavorites[index].city,
                                    rating: value
                                        .Restaurantfavorites[index].rating),
                                onTap: () {
                                  context.push('/detail/${restaurant.id}');
                                },
                                onDelete: () {
                                  value.removeFromFavorites(restaurant.id);
                                }),
                          );
                        },
                      ),
                    RestaurantFavoriteError() => Center(
                        child: Lottie.asset('assets/animations/error.json',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                            repeat: false),
                      ),
                    _ => const SizedBox()
                  };
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
