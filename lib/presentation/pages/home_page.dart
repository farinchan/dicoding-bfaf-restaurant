import 'package:dicoding_submission_restaurant/presentation/pages/setting_page.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/home/restaurant_list_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/widgets/restaurant_item.dart';
import 'package:dicoding_submission_restaurant/core/utils/restaurant_list_result_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RestaurantListProvider>().getRestaurantList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          'For You Resto',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
              onPressed: () {
                context.go(SettingPage.route);
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 10),
              child: Text(
                'What do you want to eat? \nHere are some recommendations for you!',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Expanded(
              child: Consumer<RestaurantListProvider>(
                builder: (context, value, child) {
                  return switch (value.resultState) {
                    RestaurantListLoadingState() => Center(
                          child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      )),
                    RestaurantListLoadedState(data: var restaurantList) =>
                      ListView.builder(
                        itemCount: restaurantList.restaurants.length,
                        itemBuilder: (context, index) {
                          final restaurant = restaurantList.restaurants[index];
                          return Hero(
                            tag: restaurant.pictureId,
                            child: RestaurantItem(
                                restaurant: restaurant,
                                onTap: () {
                                  context.push('/detail/${restaurant.id}');
                                }),
                          );
                        },
                      ),
                    RestaurantListErrorState() => Center(
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
