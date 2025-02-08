import 'dart:async';
import 'dart:convert';
import 'package:dicoding_submission_restaurant/data/models/request/restaurant_add_review_request.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant_add_review.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant_detail.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant_list.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant_search.dart';
import 'package:dicoding_submission_restaurant/core/constants/api_constant.dart';
import 'package:http/http.dart' as http;

class RemoteDatasource {
  final http.Client client = http.Client();

  Future<RestaurantList> getListRestaurant() async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstant.baseUrl}${ApiConstant.list}'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Connection time out'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        RestaurantList restaurantList = RestaurantList.fromJson(data);
        return restaurantList;
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantDetail> getDetailRestaurant(String id) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstant.baseUrl}${ApiConstant.detail}/$id'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Connection time out'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        RestaurantDetail restaurantDetail = RestaurantDetail.fromJson(data);
        return restaurantDetail;
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantSearch> searchRestaurant(String query) async {
    try {
      final response = await client.get(
        Uri.parse('${ApiConstant.baseUrl}${ApiConstant.search}?q=$query'),
        headers: {'Accept': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException('Connection time out'),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        RestaurantSearch restaurantSearch = RestaurantSearch.fromJson(data);
        return restaurantSearch;
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<RestaurantAddReview> addReviewRestaurant(
      RestaurantAddReviewRequest restaurantAddReview) async {
    try {
      final response = await client
          .post(
            Uri.parse('${ApiConstant.baseUrl}${ApiConstant.addReview}'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: json.encode(restaurantAddReview.toJson()),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException('Connection time out'),
          );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(response.body);
        RestaurantAddReview restaurantAddReview =
            RestaurantAddReview.fromJson(data);
        return restaurantAddReview;
      } else {
        throw Exception();
      }
    } catch (e) {
      rethrow;
    }
  }
}
