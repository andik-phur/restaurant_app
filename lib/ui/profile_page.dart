import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/platform_widgets.dart';

class ProfilePage extends StatelessWidget {
  static const String profileText = 'Profile';

  const ProfilePage({Key? key}) : super(key: key);

  Widget _buildList(BuildContext context) {
    return ListView(
      children: [
        Material(
          child: Column(
            children: [
              ListTile(
                title: Column(
                  children: const [
                    Text('turn into a seller'),
                  ],
                ),
                trailing: Switch.adaptive(
                  value: false,
                  onChanged: (value) {
                    defaultTargetPlatform == TargetPlatform.iOS
                        ? showCupertinoDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: const Text('alert!'),
                                content: const Text(
                                    'sign in or sign up before make it!'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Ok'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              );
                            },
                          )
                        : showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Center(
                                    child: Text('Alert for you !')),
                                content: const Text(
                                    'sign in or sign up before make it!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Ok'),
                                  ),
                                ],
                              );
                            },
                          );
                  },
                ),
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 190, 0, 0),
                      child: SizedBox(
                        width: 190,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text("have acount?"),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Alert for you !'),
                                            content: const Text(
                                                'this fiture is coming soon'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text('sign in'),
                                ),
                              ],
                            ),
                            const Text('or '),
                            Row(
                              children: [
                                const Text("not yet acount?"),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text('alert !'),
                                            content: const Text(
                                                'this fiture is coming soon'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Ok'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                  child: const Text('sign up'),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(profileText),
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
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(profileText),
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
