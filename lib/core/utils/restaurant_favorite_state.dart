import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';

sealed class RestaurantFavoriteState {}

class RestaurantFavoriteNone extends RestaurantFavoriteState {}

class RestaurantFavoriteLoading extends RestaurantFavoriteState {}

class RestaurantFavoriteSuccess extends RestaurantFavoriteState {
  final List<Restaurant> restaurants;

  RestaurantFavoriteSuccess(this.restaurants);
}

class RestaurantFavoriteError extends RestaurantFavoriteState {
  final String errorMessage;

  RestaurantFavoriteError(this.errorMessage);
}
