import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';
import 'package:dicoding_submission_restaurant/core/constants/api_constant.dart';
import 'package:flutter/material.dart';

class RestaurantItem extends StatelessWidget {
  final Restaurant restaurant;
  final Function() onTap;
  final Function()? onDelete;
  const RestaurantItem(
      {super.key,
      required this.restaurant,
      required this.onTap,
      this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 80,
                minHeight: 80,
                maxWidth: 120,
                minWidth: 120,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '${ApiConstant.baseUrl}${ApiConstant.imagePath}/${restaurant.pictureId}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox.square(
              dimension: 8,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          restaurant.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox.square(
                          dimension: 6,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/location.png',
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox.square(
                              dimension: 4,
                            ),
                            Expanded(
                              child: Text(
                                restaurant.city,
                                style: Theme.of(context).textTheme.bodyLarge,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/icons/star.png',
                              width: 14,
                              height: 14,
                            ),
                            const SizedBox.square(
                              dimension: 4,
                            ),
                            Expanded(
                                child: Text(
                              restaurant.rating.toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ))
                          ],
                        )
                      ],
                    ),
                  ),
                  onDelete != null
                      ? IconButton(
                          onPressed: onDelete,
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          ))
                      : const SizedBox.shrink(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
