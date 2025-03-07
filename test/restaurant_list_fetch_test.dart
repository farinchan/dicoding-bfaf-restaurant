import 'package:dicoding_submission_restaurant/core/utils/restaurant_list_result_state.dart';
import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant_list.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/home/restaurant_list_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantRepository extends Mock implements RemoteDatasource {}

void main() {
  late RestaurantListProvider restaurantListProvider;
  late MockRestaurantRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    restaurantListProvider = RestaurantListProvider(mockRepository);
  });

  group(
    'RestaurantProvider - fetchRestaurantList',
    () {
      test(
        'should fetch restaurant list successfully',
        () async {
          final mockRestaurants = RestaurantList(
            error: false,
            message: 'success',
            count: 2,
            restaurants: [
              Restaurant(
                id: 'rqdv5juczeskfw1e867',
                name: 'Melting Pot',
                description: 'A great place to eat',
                pictureId: '14',
                city: 'Medan',
                rating: 4.2,
              ),
              Restaurant(
                id: 's1knt6za9kkfw1e867',
                name: 'Kafe Kita',
                description: 'Cozy cafe',
                pictureId: '25',
                city: 'Gorontalo',
                rating: 4.0,
              ),
            ],
          );
          when(() => mockRepository.getListRestaurant())
              .thenAnswer((_) async => mockRestaurants);

          await restaurantListProvider.getRestaurantList();

          expect(restaurantListProvider.resultState,
              isA<RestaurantListLoadedState>());
          final loadedState =
              restaurantListProvider.resultState as RestaurantListLoadedState;
          expect(loadedState.data.restaurants.length, 2);
          expect(loadedState.data.restaurants[0].name, 'Melting Pot');
        },
      );

      test(
        'should handle error when fetching restaurant list fails',
        () async {
          when(() => mockRepository.getListRestaurant())
              .thenThrow(Exception('Failed to load restaurant list'));

          await restaurantListProvider.getRestaurantList();

          expect(restaurantListProvider.resultState,
              isA<RestaurantListErrorState>());
          final errorState =
              restaurantListProvider.resultState as RestaurantListErrorState;
          expect(errorState.error, 'Exception: Failed to load restaurant list');
        },
      );
    },
  );
}
