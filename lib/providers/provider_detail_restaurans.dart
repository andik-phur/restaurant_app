import 'package:flutter/material.dart';
import '../data/model/restaurans_detail.dart';
import '../data/api_restaurant/api_restaurants.dart';
import '../utils/enum.dart';

class DetailRestauransProvider extends ChangeNotifier {
  final ApiServices apiService;
  final String id;

  DetailRestauransProvider({required this.apiService, required this.id}) {
    _fetchAllData();
  }

  late DetailRestauranResults _detailResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailRestauranResults get result => _detailResult;

  ResultState get state => _state;

  void reload() {
    _fetchAllData();
    notifyListeners();
  }

  Future<dynamic> _fetchAllData() async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final detail = await apiService.detail(id);
      _state = ResultState.Success;
      notifyListeners();
      return _detailResult = detail;
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'can not recive data. cek your conection';
    }
  }
}
