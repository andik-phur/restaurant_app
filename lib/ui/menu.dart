import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurants_project/ui/favorite_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import '../widgets/platform_widgets.dart';
import 'home_restaurants_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int _bottomNavIndex = 0;

  final List<Widget> _listWidget = [
    const HomeRestauransPage(),
    const SearchPage(),
    const FavoritePage(),
    const ProfilePage(),
  ];

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Platform.isIOS ? CupertinoIcons.home : Icons.home,
      ),
      label: HomeRestauransPage.homeText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.search_circle : Icons.search),
      label: SearchPage.searchText,
    ),
    BottomNavigationBarItem(
      icon: Icon(
          Platform.isIOS ? CupertinoIcons.square_favorites : Icons.favorite),
      label: FavoritePage.favoriteText,
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS
          ? CupertinoIcons.profile_circled
          : Icons.account_circle),
      label: ProfilePage.profileText,
    ),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: _bottomNavBarItems,
      ),
      tabBuilder: (context, index) {
        return _listWidget[index];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
