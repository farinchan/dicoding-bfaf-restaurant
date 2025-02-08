import 'package:dicoding_submission_restaurant/data/models/response/restaurant_list.dart';

sealed class RestaurantListResultState {}

class RestaurantListNoneState extends RestaurantListResultState {}

class RestaurantListLoadingState extends RestaurantListResultState {}

class RestaurantListErrorState extends RestaurantListResultState {
  final String error;

  RestaurantListErrorState({required this.error});
}

class RestaurantListLoadedState extends RestaurantListResultState {
  final RestaurantList data;

  RestaurantListLoadedState({required this.data});
}
