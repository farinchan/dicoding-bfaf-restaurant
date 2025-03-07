import 'package:dicoding_submission_restaurant/core/utils/restaurant_search_result_state.dart';
import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant_search.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/search/restaurant_search_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantRepository extends Mock implements RemoteDatasource {}

void main() {
  late RestaurantSearchProvider restaurantSearchProvider;
  late MockRestaurantRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    restaurantSearchProvider = RestaurantSearchProvider(mockRepository);
  });

  group(
    'RestaurantProvider - searchRestaurants',
    () {
      test(
        'should search restaurants successfully',
        () async {
          final mockRestaurants = RestaurantSearch(
            error: false,
            founded: 1,
            restaurants: [
              Restaurant(
                id: 'rqdv5juczeskfw1e867',
                name: 'Melting Pot',
                description: 'A great place to eat',
                pictureId: '14',
                city: 'Medan',
                rating: 4.2,
              ),
            ],
          );

          when(() => mockRepository.searchRestaurant('Melting'))
              .thenAnswer((_) async => mockRestaurants);

          await restaurantSearchProvider.searchRestaurant('Melting');

          expect(restaurantSearchProvider.resultState,
              isA<RestaurantSearchLoadedState>());
          final loadedState = restaurantSearchProvider.resultState
              as RestaurantSearchLoadedState;
          expect(loadedState.data.restaurants.length, 1);
          expect(loadedState.data.restaurants[0].name, 'Melting Pot');
        },
      );

      test(
        'should handle error when searching restaurants fails',
        () async {
          when(() => mockRepository.searchRestaurant('Random'))
              .thenThrow(Exception('Failed to search restaurants'));

          await restaurantSearchProvider.searchRestaurant('Random');

          expect(restaurantSearchProvider.resultState,
              isA<RestaurantSearchErrorState>());
          final errorState = restaurantSearchProvider.resultState
              as RestaurantSearchErrorState;
          expect(errorState.error, 'Exception: Failed to search restaurants');
        },
      );
    },
  );
}
