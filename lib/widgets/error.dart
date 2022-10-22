import 'package:flutter/material.dart';
import '../providers/provider_restaurans.dart';
import '../providers/provider_detail_restaurans.dart';
import '../providers/search_restaurants.dart';

Flex restaurants(RestaurantsProvider state, BuildContext context) {
  return Flex(
    direction: Axis.vertical,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.error,
        size: 80,
      ),
      Text(
        state.message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
      const SizedBox(
        height: 24,
      ),
      ElevatedButton(
        onPressed: () {
          state.reload();
        },
        child: const Text(
          "Try Again",
          style: TextStyle(color: Colors.black),
        ),
      ),
    ],
  );
}

Flex errordetailrestaurant(
    DetailRestauransProvider state, BuildContext context) {
  return Flex(
    direction: Axis.vertical,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.error_outline,
        size: 90,
      ),
      Text(
        state.message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
      const SizedBox(
        height: 34,
      ),
      ElevatedButton(
        onPressed: () {
          state.reload();
        },
        child: const Text(
          "Trt Again",
          style: TextStyle(color: Colors.yellow),
        ),
      ),
    ],
  );
}

Flex errorsearch(SearchRestauransProvider state, BuildContext context) {
  return Flex(
    direction: Axis.vertical,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Icon(
        Icons.error,
        size: 80,
      ),
      Text(
        state.message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    ],
  );
}
