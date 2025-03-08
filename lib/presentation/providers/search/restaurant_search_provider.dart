import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/core/utils/restaurant_search_result_state.dart';
import 'package:flutter/material.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final RemoteDatasource _remoteDatasource;

  RestaurantSearchProvider(this._remoteDatasource);

  RestaurantSearchResultState _resultState = RestaurantSearchNoneState();

  RestaurantSearchResultState get resultState => _resultState;

  Future<void> searchRestaurant(String query) async {
    try {
      _resultState = RestaurantSearchLoadingState();
      notifyListeners();

      final result = await _remoteDatasource.searchRestaurant(query);

      if (result.error) {
        _resultState =
            RestaurantSearchErrorState(error: 'Something went wrong!');
        notifyListeners();
      } else {
        _resultState = RestaurantSearchLoadedState(data: result);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantSearchErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
