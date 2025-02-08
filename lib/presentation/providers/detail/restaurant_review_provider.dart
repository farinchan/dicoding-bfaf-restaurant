import 'package:dicoding_submission_restaurant/data/models/request/restaurant_add_review_request.dart';
import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:flutter/material.dart';

class RestaurantReviewProvider extends ChangeNotifier {
  final RemoteDatasource _remoteDatasource;

  RestaurantReviewProvider(this._remoteDatasource);

  Future<void> addReview(RestaurantAddReviewRequest request) async {
    await _remoteDatasource.addReviewRestaurant(request);
  }
}
