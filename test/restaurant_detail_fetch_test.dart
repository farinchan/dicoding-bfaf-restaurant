import 'package:dicoding_submission_restaurant/core/utils/restaurant_detail_result_state.dart';
import 'package:dicoding_submission_restaurant/data/datasources/remote_datasource.dart';
import 'package:dicoding_submission_restaurant/data/models/response/restaurant_detail.dart';
import 'package:dicoding_submission_restaurant/presentation/providers/detail/restaurant_detail_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRestaurantRepository extends Mock implements RemoteDatasource {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RestaurantDetailProvider provider;
  late MockRestaurantRepository mockRepository;

  setUp(() {
    mockRepository = MockRestaurantRepository();
    provider = RestaurantDetailProvider(mockRepository);
  });

  group(
    'RestaurantDetailProvider - fetchRestaurantDetail',
    () {
      test("should return restaurant detail initial state", () {
        expect(provider.resultState, isA<RestaurantDetailNoneState>());
      });

      test('should fetch restaurant detail successfully', () async {
        final mockRestaurantDetail = RestaurantDetail(
          error: false,
          message: "success",
          restaurant: Restaurant(
            id: "zvf11c0sukfw1e867",
            name: "Gigitan Cepat",
            description:
                "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue.",
            city: "Bali",
            address: "Jln. Belimbing Timur no 27",
            pictureId: "38",
            categories: [
              Category(name: "Italia"),
              Category(name: "Sop"),
            ],
            menus: Menus(
              foods: [
                Category(name: "Tumis leek"),
                Category(name: "Paket rosemary"),
              ],
              drinks: [
                Category(name: "Jus apel"),
                Category(name: "Air"),
              ],
            ),
            rating: 4.0,
            customerReviews: [
              CustomerReview(
                  name: "Arif",
                  review: "Saya sangat suka menu malamnya!",
                  date: "13 November 2019"),
              CustomerReview(
                  name: "Gilang",
                  review: "Harganya murah sekali!",
                  date: "13 Juli 2019"),
            ],
          ),
        );

        when(() => mockRepository.getDetailRestaurant("zvf11c0sukfw1e867"))
            .thenAnswer((_) async => mockRestaurantDetail);

        await provider.getDetailRestaurant("zvf11c0sukfw1e867");

        expect(provider.resultState, isA<RestaurantDetailLoadedState>());
        final successState =
            provider.resultState as RestaurantDetailLoadedState;
        expect(successState.data.id, "zvf11c0sukfw1e867");
        expect(successState.data.name, "Gigitan Cepat");
        expect(successState.data.city, "Bali");
      });

      test(
        'should handle error when fetching restaurant detail fails',
        () async {
          when(() => mockRepository.getDetailRestaurant("zvf11c0sukfw1e867"))
              .thenThrow(Exception('Failed to load restaurant details'));

          await provider.getDetailRestaurant("zvf11c0sukfw1e867");

          expect(provider.resultState, isA<RestaurantDetailErrorState>());
          final errorState = provider.resultState as RestaurantDetailErrorState;
          expect(
              errorState.error, 'Exception: Failed to load restaurant details');
        },
      );
    },
  );
}
