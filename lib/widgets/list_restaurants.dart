import 'package:flutter/material.dart';
import '../data/model/restaurants.dart';

Widget buildRestaurantItem(BuildContext context, Restaurants restaurant) {
  Size screenSize = MediaQuery.of(context).size;
  const String baseImageUrl =
      "https://restaurant-api.dicoding.dev/images/small/";

  return ListTile(
    textColor: Colors.black,
    contentPadding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.035,
        vertical: screenSize.width * 0.005),
    leading: ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Image.network(
        baseImageUrl + restaurant.pictureId,
        width: 100,
        fit: BoxFit.cover,
      ),
    ),
    title: Text(
      restaurant.name,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: screenSize.width * 0.04),
    ),
    subtitle: Flex(
      direction: Axis.vertical,
      children: [
        SizedBox(height: screenSize.width * 0.017),
        Flex(
          direction: Axis.horizontal,
          children: [
            Flexible(
              child: Icon(
                Icons.location_pin,
                color: Colors.green,
                size: screenSize.width * 0.04,
              ),
            ),
            SizedBox(width: screenSize.width * 0.012),
            Flexible(
              child: FittedBox(
                child: Text(
                  restaurant.city,
                  style: TextStyle(
                      color: Colors.grey, fontSize: screenSize.width * 0.04),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: screenSize.width * 0.01),
        Flex(
          direction: Axis.horizontal,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Icon(
                Icons.star,
                color: Colors.amber,
                size: screenSize.width * 0.035,
              ),
            ),
            SizedBox(width: screenSize.width * 0.017),
            Flexible(
              child: Text(
                restaurant.rating.toString(),
                style: TextStyle(
                    color: Colors.grey, fontSize: screenSize.width * 0.035),
              ),
            ),
          ],
        ),
      ],
    ),
    onTap: () {
      Navigator.pushNamed(context, "/details_page", arguments: restaurant.id);
    },
  );
}
