import 'package:flutter/material.dart';
import '../data/database/database_helper.dart';
import '../data/model/restaurants.dart';
import '../utils/enum.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getData();
  }

  late ResultState _state = ResultState.NoData;
  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  List<Restaurants> _favorite = [];
  List<Restaurants> get favorite => _favorite;

  void _getData() async {
    _favorite = await databaseHelper.getData();
    if (_favorite.isNotEmpty) {
      _state = ResultState.HasData;
    } else {
      _state = ResultState.NoData;
      _message = 'Empty Data';
    }
    notifyListeners();
  }

  void addData(Restaurants restaurant) async {
    try {
      await databaseHelper.insertData(restaurant);
      _getData();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final favoriteRestaurant = await databaseHelper.getDataById(id);
    return favoriteRestaurant.isNotEmpty;
  }

  void removeData(String id) async {
    try {
      await databaseHelper.removeData(id);
      _getData();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  void complete(String testModuleName) {}
}
