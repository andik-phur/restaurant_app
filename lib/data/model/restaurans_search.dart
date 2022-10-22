import 'dart:convert';
import 'package:restaurants_project/data/model/restaurants.dart';

SearchResults searchResultFromJson(String str) =>
    SearchResults.fromJson(json.decode(str));

class SearchResults {
  SearchResults({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  bool error;
  int founded;
  List<Restaurants> restaurants;

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurants>.from(
            json["restaurants"].map((x) => Restaurants.fromJson(x))),
      );
}
