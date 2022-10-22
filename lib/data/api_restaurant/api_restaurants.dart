import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/restaurans_detail.dart';
import '../model/restaurans_search.dart';
import '../model/restaurants.dart';

class ApiServices {
  final http.Client client;
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';
  ApiServices(this.client);

  Future<RestaurantsResult> getList() async {
    final response = await client.get(Uri.parse("$_baseUrl/list"));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Load data error');
    }
  }

  Future<SearchResults> search(String keyword) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$keyword"));
    if (response.statusCode == 200) {
      return SearchResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Load data error');
    }
  }

  Future<DetailRestauranResults> detail(String id) async {
    final response = await client.get(Uri.parse("$_baseUrl/detail/$id"));
    if (response.statusCode == 200) {
      return DetailRestauranResults.fromJson(json.decode(response.body));
    } else {
      throw Exception('Load data error');
    }
  }
}
