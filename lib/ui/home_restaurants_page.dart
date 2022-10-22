import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/provider_restaurans.dart';
import '../utils/enum.dart';
import '../widgets/list_restaurants.dart';
import '../widgets/platform_widgets.dart';
import '../widgets/error.dart';

class HomeRestauransPage extends StatelessWidget {
  const HomeRestauransPage({Key? key}) : super(key: key);
  static const String homeText = 'Home';

  Widget _buildList(BuildContext context) {
    return Consumer<RestaurantsProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.Loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.state == ResultState.HasData) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: state.result.restaurants.length,
            itemBuilder: (context, index) {
              var restaurant = state.result.restaurants[index];
              return buildRestaurantItem(context, restaurant);
            },
          );
        } else if (state.state == ResultState.NoData) {
          return Center(
            child: Text(state.message),
          );
        } else if (state.state == ResultState.Error) {
          return restaurants(state, context);
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant'),
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
      body: NestedScrollView(
        headerSliverBuilder: (context, isScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              collapsedHeight: 80,
              pinned: true,
              flexibleSpace: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/home.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    color: Colors.black45,
                  ),
                  Flex(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    direction: Axis.vertical,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenSize.width * 0.04,
                          bottom: screenSize.height * 0.005,
                        ),
                        child: Flex(
                          direction: Axis.horizontal,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Find your Restaurant',
                              style: TextStyle(
                                fontSize: screenSize.aspectRatio * 45,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, "/search_page");
                                  },
                                  child: const Icon(
                                    Icons.search,
                                    size: 33.0,
                                    color: Colors.orange,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: screenSize.width * 0.04,
                        ),
                        child: Text(
                          'Recommended restaurants just for you !',
                          style: TextStyle(
                            fontSize: screenSize.aspectRatio * 31.05,
                            color: Colors.orangeAccent,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ];
        },
        body: _buildList(context),
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Restaurant'),
        trailing: GestureDetector(
          child: const Icon(CupertinoIcons.search),
          onTap: () {
            Navigator.pushNamed(context, "/search_page");
          },
        ),
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
