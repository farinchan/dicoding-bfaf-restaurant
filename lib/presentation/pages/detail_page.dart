import 'dart:developer';

import 'package:dicoding_submission_restaurant/core/utils/restaurant_detail_result_state.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/detail/restaurant_detail_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/favorite/restaurant_favorite_list_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/widgets/food_drink_item.dart';
import 'package:dicoding_submission_restaurant/presentation/widgets/review_item.dart';
import 'package:dicoding_submission_restaurant/presentation/widgets/review_dialog.dart';
import 'package:dicoding_submission_restaurant/core/constants/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class DetailPage extends StatefulWidget {
  static const String route = '/detail';
  final String id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantDetailProvider>().getDetailRestaurant(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider =
        Provider.of<RestaurantFavoriteListProvider>(context, listen: false);

    return Scaffold(
        body: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Consumer<RestaurantDetailProvider>(
                builder: (context, value, child) {
                  bool isFavorite = favoriteProvider.Restaurantfavorites.any(
                      (r) => r.id == widget.id);
                  return switch (value.resultState) {
                    RestaurantDetailLoadingState() => LinearProgressIndicator(),
                    RestaurantDetailLoadedState(data: var restaurant) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Hero(
                                tag: restaurant.pictureId,
                                child: Image.network(
                                  '${ApiConstant.baseUrl}${ApiConstant.imagePath}/${restaurant.pictureId}',
                                  fit: BoxFit.cover,
                                  width: MediaQuery.of(context).size.width / 1,
                                ),
                              ),
                              SafeArea(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 16),
                                      child: GestureDetector(
                                        onTap: () => context.pop(),
                                        child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary),
                                          child: Center(
                                            child: Icon(
                                              Icons.arrow_back_ios,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Consumer<
                                          RestaurantFavoriteListProvider>(
                                        builder:
                                            (context, favoriteProvider, child) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 16),
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (favoriteProvider.isLoading)
                                                  return;
                                                if (isFavorite) {
                                                  log('remove from favorite restaurant: ${restaurant}');
                                                  await favoriteProvider
                                                      .removeFromFavorites(
                                                          restaurant.id);
                                                  isFavorite = !isFavorite;
                                                } else {
                                                  log('add to favorite restaurant: ${restaurant.name}');
                                                  await favoriteProvider
                                                      .addToFavorites(
                                                          Restaurant(
                                                    id: restaurant.id,
                                                    name: restaurant.name,
                                                    description:
                                                        restaurant.description,
                                                    pictureId:
                                                        restaurant.pictureId,
                                                    city: restaurant.city,
                                                    rating: restaurant.rating,
                                                  ));
                                                  isFavorite = !isFavorite;
                                                  ScaffoldMessenger.of(context)
                                                      .clearSnackBars();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Added to favorite'),
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 7, 197, 105),
                                                  ));
                                                }
                                              },
                                              child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary),
                                                child: Center(
                                                  child: Icon(
                                                    isFavorite
                                                        ? Icons.favorite
                                                        : Icons.favorite_border,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, right: 16, top: 14, bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  restaurant.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/star.png',
                                      width: 16,
                                      height: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${restaurant.rating}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/icons/location.png',
                                  width: 14,
                                  height: 14,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  '${restaurant.address}, ${restaurant.city}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            child: Text(
                              restaurant.description,
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              'List Foods',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: restaurant.menus.foods
                                  .map((food) => FoodDrinkItem(menu: food.name))
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 14),
                            child: Text(
                              'List Drinks',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 8,
                              children: restaurant.menus.drinks
                                  .map((drink) =>
                                      FoodDrinkItem(menu: drink.name))
                                  .toList(),
                            ),
                          ),
                          SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 14),
                            child: Text(
                              'Reviews',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          SizedBox(height: 18),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: ListView.builder(
                              reverse: true,
                              padding: const EdgeInsets.only(top: 8),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final review =
                                    restaurant.customerReviews[index];
                                return ReviewItem(
                                    name: review.name,
                                    review: review.review,
                                    date: review.date);
                              },
                              itemCount: restaurant.customerReviews.length,
                            ),
                          ),
                        ],
                      ),
                    RestaurantDetailErrorState() => Center(
                        child: Lottie.asset('assets/animations/error.json',
                            width: 300,
                            height: 300,
                            fit: BoxFit.cover,
                            repeat: false)),
                    _ => const SizedBox()
                  };
                },
              )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return ReviewDialog(
                    id: widget.id,
                  );
                });
          },
          child: const Icon(Icons.comment),
        ));
  }
}
