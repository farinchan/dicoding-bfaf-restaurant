
import 'package:dicoding_submission_restaurant/data/models/response/restaurant_detail.dart';

sealed class RestaurantDetailResultState {}

class RestaurantDetailNoneState extends RestaurantDetailResultState {}

class RestaurantDetailLoadingState extends RestaurantDetailResultState {}

class RestaurantDetailErrorState extends RestaurantDetailResultState {
  final String error;

  RestaurantDetailErrorState({required this.error});
}

class RestaurantDetailLoadedState extends RestaurantDetailResultState {
  final Restaurant data;

  RestaurantDetailLoadedState({required this.data});
}
