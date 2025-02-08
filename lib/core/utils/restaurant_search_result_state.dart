import 'package:dicoding_submission_restaurant/data/models/response/restaurant_search.dart';

sealed class RestaurantSearchResultState {}

class RestaurantSearchNoneState extends RestaurantSearchResultState {}

class RestaurantSearchLoadingState extends RestaurantSearchResultState {}

class RestaurantSearchErrorState extends RestaurantSearchResultState {
  final String error;

  RestaurantSearchErrorState({required this.error});
}

class RestaurantSearchLoadedState extends RestaurantSearchResultState {
  final RestaurantSearch data;

  RestaurantSearchLoadedState({required this.data});
}
