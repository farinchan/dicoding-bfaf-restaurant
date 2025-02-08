import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/core/utils/restaurant_detail_result_state.dart';
import 'package:flutter/material.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final RemoteDatasource _remoteDatasource;

  RestaurantDetailProvider(this._remoteDatasource);

  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();

  RestaurantDetailResultState get resultState => _resultState;

  Future<void> getDetailRestaurant(String id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();

      final response = await _remoteDatasource.getDetailRestaurant(id);

      if (response.error) {
        _resultState = RestaurantDetailErrorState(error: response.message);
        notifyListeners();
      } else {
        _resultState = RestaurantDetailLoadedState(data: response.restaurant);
        notifyListeners();
      }
    } on Exception catch (e) {
      _resultState = RestaurantDetailErrorState(error: e.toString());
      notifyListeners();
    }
  }
}
