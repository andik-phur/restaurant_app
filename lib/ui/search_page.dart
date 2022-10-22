import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/model/restaurants.dart';
import '../providers/search_restaurants.dart';
import '../utils/enum.dart';
import '../widgets/platform_widgets.dart';
import '../widgets/error.dart';

class SearchPage extends StatelessWidget {
  static const String searchText = 'search restaurant';

  const SearchPage({Key? key}) : super(key: key);

  Widget _buildList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter keywords",
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  Provider.of<SearchRestauransProvider>(context, listen: false)
                      .search(text);
                }
              }),
        ),
        Consumer<SearchRestauransProvider>(
          builder: (context, state, _) {
            if (state.state == ResultState.Loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == ResultState.HasData) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.result.restaurants.length,
                itemBuilder: (context, index) {
                  var restaurant = state.result.restaurants[index];
                  return _buildRestaurantItem(context, restaurant);
                },
              );
            } else if (state.state == ResultState.NoData) {
              return Center(
                child: Text(state.message),
              );
            } else if (state.state == ResultState.Error) {
              return errorsearch(state, context);
            } else {
              return const Center(child: Text(''));
            }
          },
        )
      ]),
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurants restaurant) {
    Size screenSize = MediaQuery.of(context).size;
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
                          color: Colors.grey,
                          fontSize: screenSize.width * 0.04),
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
          Navigator.pushNamed(context, "/details_page",
              arguments: restaurant.id);
        },
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(searchText),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(searchText),
      ),
      body: (_buildList(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SearchRestauransProvider(),
      child: PlatformWidget(
        androidBuilder: _buildAndroid,
        iosBuilder: _buildIos,
      ),
    );
  }
}
