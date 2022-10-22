import 'package:flutter/material.dart';
import '../data/api_restaurant/api_restaurants.dart';
import '../data/model/restaurants.dart';
import '../utils/enum.dart';

class RestaurantsProvider extends ChangeNotifier {
  final ApiServices apiService;

  RestaurantsProvider({required this.apiService}) {
    _fetchAllData();
  }

  late RestaurantsResult _restaurantResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  RestaurantsResult get result => _restaurantResult;

  ResultState get state => _state;

  void reload() {
    _fetchAllData();
    notifyListeners();
  }

  Future<dynamic> _fetchAllData() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final restaurant = await apiService.getList();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Data not found';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'can not recive data. cek your conection';
    }
  }
}
