import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/model/restaurants.dart';
import '../providers/database_provider_favorite.dart';
import '../utils/enum.dart';
import '../widgets/platform_widgets.dart';

class FavoritePage extends StatelessWidget {
  static const routeName = "/favorite_screen";
  static const String favoriteText = 'Favorite';

  const FavoritePage({super.key});

  Widget _buildList(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.favorite.length,
            itemBuilder: (context, index) {
              var restaurant = state.favorite[index];
              return buildFavoriteItem(context, restaurant);
            },
          );
        } else if (state.state == ResultState.NoData) {
          return Center(
            child: Text(state.message),
          );
        } else if (state.state == ResultState.Error) {
          return Column(
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
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }

  Widget buildFavoriteItem(BuildContext context, Restaurants restaurant) {
    const String baseImageUrl =
        "https://restaurant-api.dicoding.dev/images/small/";
    return Material(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        leading: Hero(
          tag: restaurant.pictureId,
          child: Image.network(
            baseImageUrl + restaurant.pictureId,
            width: 100,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(restaurant.name),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  size: 14,
                ),
                Text(restaurant.rating.toString())
              ],
            ),
          ],
        ),
        subtitle: Row(
          children: [
            const Icon(
              Icons.location_pin,
              size: 14,
            ),
            Text(restaurant.city)
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, "/details_page",
              arguments: restaurant.id);
        },
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(favoriteText),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/setings_page");
                },
                child: const Icon(
                  Icons.settings,
                  size: 26.0,
                ),
              ))
        ],
      ),
      body: (_buildList(context)),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(favoriteText),
      ),
      child: _buildList(context),
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
