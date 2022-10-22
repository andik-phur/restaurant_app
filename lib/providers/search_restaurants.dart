import 'package:flutter/material.dart';
import '../data/api_restaurant/api_restaurants.dart';
import '../data/model/restaurans_search.dart';
import '../utils/enum.dart';
import 'package:http/http.dart' as http;

class SearchRestauransProvider extends ChangeNotifier {
  ApiServices apiService = ApiServices(http.Client());
  late SearchResults _searchResult;
  late String _keyword;
  ResultState _state = ResultState.NoData;
  String _message = '';

  String get message => _message;

  String get keyword => _keyword;

  SearchResults get result => _searchResult;

  ResultState get state => _state;

  void search(String key) {
    _keyword = key;
    _fetchAllData();
    notifyListeners();
  }

  Future<dynamic> _fetchAllData() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.search(keyword);
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Data not found';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _searchResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'can not recive data. cek your conection';
    }
  }
}
