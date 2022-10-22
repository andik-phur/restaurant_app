import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_project/data/model/restaurants.dart';
import '../data/api_restaurant/api_restaurants.dart';
import '../data/model/restaurans_detail.dart';
import '../providers/database_provider_favorite.dart';
import '../providers/provider_detail_restaurans.dart';
import '../utils/enum.dart';
import '../widgets/menu_restaurants.dart';
import '../widgets/error.dart';
import 'package:http/http.dart' as http;

class DetailRestauransPage extends StatelessWidget {
  final String id;

  const DetailRestauransPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DetailRestauransProvider>(
        create: (_) => DetailRestauransProvider(
            apiService: ApiServices(http.Client()), id: id),
        child: const Detail());
  }
}

class Detail extends StatelessWidget {
  const Detail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DetailRestauransProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.state == ResultState.Success) {
            return _buildDetail(context, state.result.restaurant);
          } else if (state.state == ResultState.Error) {
            return errordetailrestaurant(state, context);
          } else {
            return const Center(child: Text(''));
          }
        },
      ),
    );
  }

  SafeArea _buildDetail(BuildContext context, DetailRestaurants restaurant) {
    Size screenSize = MediaQuery.of(context).size;

    return SafeArea(
      child: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [sliverAppBar(restaurant)];
        },
        body: Padding(
          padding: EdgeInsets.only(
            top: screenSize.height * 0.03,
            left: screenSize.width * 0.07,
            right: screenSize.width * 0.07,
          ),
          child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          restaurant.name,
                          style: TextStyle(
                            fontSize: screenSize.width * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: Colors.green,
                              size: screenSize.width * 0.045,
                            ),
                            SizedBox(
                              width: screenSize.width * 0.015,
                            ),
                            Text(
                              restaurant.city,
                              style:
                                  TextStyle(fontSize: screenSize.width * 0.035),
                            ),
                          ],
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: screenSize.width * 0.04,
                            ),
                            SizedBox(
                              width: screenSize.width * 0.015,
                            ),
                            Text(
                              restaurant.rating.toString(),
                              style:
                                  TextStyle(fontSize: screenSize.width * 0.035),
                            ),
                          ],
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          'Description',
                          style: TextStyle(
                              fontSize: screenSize.width * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Text(
                          restaurant.description,
                          style: TextStyle(fontSize: screenSize.width * 0.035),
                        ),
                        SizedBox(height: screenSize.height * 0.02),
                        Text(
                          'Foods Menu !',
                          style: TextStyle(
                              fontSize: screenSize.width * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: restaurant.menus.foods.map(
                                (food) {
                                  return MenuCard(
                                      name: food.name,
                                      image: 'assets/food.jpg');
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        Text(
                          'Drinks Menu !',
                          style: TextStyle(
                              fontSize: screenSize.width * 0.045,
                              fontWeight: FontWeight.bold),
                        ),
                        Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Flex(
                              direction: Axis.horizontal,
                              children: restaurant.menus.drinks.map(
                                (drinks) {
                                  return MenuCard(
                                      name: drinks.name,
                                      image: 'assets/food.jpg');
                                },
                              ).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.05,
                        ),
                        Text(
                          "Customer Review",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        Flex(
                          direction: Axis.vertical,
                          children: restaurant.customerReviews.map((review) {
                            return _reviewRestaurans(
                                review, context, restaurant);
                          }).toList(),
                        ),
                      ],
                    );
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Consumer sliverAppBar(DetailRestaurants restaurant) {
    const String baseImageUrl =
        "https://restaurant-api.dicoding.dev/images/small/";

    return Consumer<DatabaseProvider>(builder: (context, provider, child) {
      Size screenSize = MediaQuery.of(context).size;

      return FutureBuilder<bool>(
        future: provider.isFavorite(restaurant.id),
        builder: (context, snapshot) {
          var isFavorite = snapshot.data ?? false;
          return SliverAppBar(
            title: Text(restaurant.name,
                style: TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: screenSize.width * 0.05,
                    fontWeight: FontWeight.bold)),
            actions: [
              Text('add your fav',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: screenSize.width * 0.035,
                  )),
              CircleAvatar(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                child: isFavorite
                    ? IconButton(
                        icon: const Icon(Icons.favorite),
                        onPressed: () => provider.removeData(restaurant.id),
                      )
                    : IconButton(
                        icon: const Icon(Icons.favorite_outline),
                        onPressed: () => provider.addData(
                          Restaurants(
                              id: restaurant.id,
                              name: restaurant.name,
                              description: restaurant.description,
                              pictureId: restaurant.pictureId,
                              city: restaurant.city,
                              rating: restaurant.rating),
                        ),
                      ),
              ),
            ],
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: restaurant.pictureId,
                    child: Image.network(
                      baseImageUrl + restaurant.pictureId,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  color: Colors.black54,
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Material _reviewRestaurans(CustomerReview review, BuildContext context,
      DetailRestaurants restaurant) {
    Size screenSize = MediaQuery.of(context).size;

    return Material(
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 7.0, vertical: 7.0),
        title: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(review.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: screenSize.width * 0.035,
                )),
            Text(review.date,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: screenSize.width * 0.035,
                ))
          ],
        ),
        subtitle: Text(review.review,
            style: TextStyle(
              color: Colors.red,
              fontSize: screenSize.width * 0.035,
            )),
      ),
    );
  }
}
