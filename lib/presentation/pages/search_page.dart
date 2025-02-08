import 'package:dicoding_submission_restaurant/presentation/providers/search/restaurant_search_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/theme/theme_provider.dart';
import 'package:dicoding_submission_restaurant/presentation/widgets/restaurant_item.dart';
import 'package:dicoding_submission_restaurant/core/utils/restaurant_search_result_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<RestaurantSearchProvider>()
          .searchRestaurant(_controller.text);
    });
  }

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: SearchBar(
            leading: Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            elevation: WidgetStateProperty.all(0),
            controller: _controller,
            hintText: 'Search Restaurant',
            hintStyle: WidgetStateProperty.all(Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Theme.of(context).colorScheme.tertiary)),
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16)),
            onChanged: (value) {
              context.read<RestaurantSearchProvider>().searchRestaurant(value);
            },
            onSubmitted: (value) {
              context.read<RestaurantSearchProvider>().searchRestaurant(value);
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(10.0),
            child: SizedBox(),
          ),
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Consumer<ThemeProvider>(
                  builder: (context, value, child) => GestureDetector(
                    onTap: () => value.toggleTheme = value.isDark,
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
        body: ConstrainedBox(
          constraints: BoxConstraints(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Consumer<RestaurantSearchProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  RestaurantSearchLoadingState() => Center(
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: 240,
                        height: 240,
                        fit: BoxFit.contain,
                      ),
                    ),
                  RestaurantSearchLoadedState(data: var restaurantSearch) =>
                    restaurantSearch.restaurants.isEmpty
                        ? Center(
                            child: Text('"${_controller.text}" not found',
                                style: Theme.of(context).textTheme.titleSmall),
                          )
                        : ListView.builder(
                            itemCount: restaurantSearch.restaurants.length,
                            itemBuilder: (context, index) {
                              final restaurant =
                                  restaurantSearch.restaurants[index];
                              return RestaurantItem(
                                restaurant: restaurant,
                                onTap: () {
                                  context.push('/detail/${restaurant.id}');
                                },
                              );
                            },
                          ),
                  RestaurantSearchErrorState() => Center(
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
          ),
        ));
  }
}
