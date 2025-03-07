import 'dart:developer';

import 'package:dicoding_submission_restaurant/core/utils/restaurant_favorite_state.dart';
import 'package:dicoding_submission_restaurant/core/services/sqflite_service.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';
import 'package:flutter/material.dart';

class RestaurantFavoriteListProvider extends ChangeNotifier {
  RestaurantFavoriteState _resultState = RestaurantFavoriteNone();
  RestaurantFavoriteState get resultState => _resultState;

  final SqliteService _sqliteService;
  List<Restaurant> _Restaurantfavorites = [];
  bool _isLoading = false;

  RestaurantFavoriteListProvider(this._sqliteService) {
    loadFavorites();
  }

  List<Restaurant> get Restaurantfavorites => _Restaurantfavorites;
  bool get isLoading => _isLoading;

  Future<void> loadFavorites() async {
    _resultState = RestaurantFavoriteLoading();
    notifyListeners();

    try {
      _Restaurantfavorites = await _sqliteService.getAllItems();
      _resultState = RestaurantFavoriteSuccess(_Restaurantfavorites);
    } catch (e) {
      log("Error loading favorites:" + e.toString(),
          name: "RestaurantFavoriteListProvider");
      _resultState = RestaurantFavoriteError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future addToFavorites(Restaurant restaurant) async {
    var msg = "";

    try {
      _isLoading = true;
      msg = "success add to favorite";

      notifyListeners();

      await _sqliteService.insertItem(restaurant);
    } catch (e) {
      msg = "Error adding to favorites: $e";
    }
    _isLoading = false;
    notifyListeners();
    return msg;
  }

  Future removeFromFavorites(String restaurantId) async {
    var msg = "";
    try {
      _isLoading = true;
      msg = "success remove from favorite";

      await _sqliteService.removeItem(restaurantId);
      loadFavorites();
      notifyListeners();
    } catch (e) {
      log("Error removing from favorites:" + e.toString(),
          name: "RestaurantFavoriteListProvider");
      msg = "Error removing from favorites: $e";
    }
    _isLoading = false;
    notifyListeners();
    return msg;
  }
}
