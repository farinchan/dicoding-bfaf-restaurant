import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/core/utils/restaurant_list_result_state.dart';
import 'package:flutter/material.dart';

class RestaurantListProvider extends ChangeNotifier {
  final RemoteDatasource _remoteDatasource;

  RestaurantListProvider(this._remoteDatasource);

  RestaurantListResultState _resultState = RestaurantListNoneState();

  RestaurantListResultState get resultState => _resultState;

  Future<void> getRestaurantList() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      final result = await _remoteDatasource.getListRestaurant();

      if (result.error) {
        _resultState = RestaurantListErrorState(error: result.message);
        notifyListeners();
      } else {
        _resultState = RestaurantListLoadedState(data: result);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantListErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
