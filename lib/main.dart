import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurants_project/providers/preference_provider.dart';
import 'package:restaurants_project/providers/provider_restaurans.dart';
import 'package:restaurants_project/providers/database_provider_favorite.dart';
import 'package:restaurants_project/providers/scedhuling_provider.dart';
import 'package:restaurants_project/ui/detail_restaurans.dart';
import 'package:restaurants_project/ui/menu.dart';
import 'package:restaurants_project/ui/setings_page.dart';
import 'package:restaurants_project/utils/page_pop_navigations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/api_restaurant/api_restaurants.dart';
import 'data/database/database_helper.dart';
import 'data/preference_helper/preference_helper.dart';
import 'notif/background_service.dart';
import 'notif/notif_helper.dart';
import 'ui/search_page.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();
  service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) =>
                RestaurantsProvider(apiService: ApiServices(http.Client()))),
        ChangeNotifierProvider(
            create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper())),
        ChangeNotifierProvider(create: (_) => SchedulingProvider()),
        ChangeNotifierProvider(
          create: (_) => PreferenceProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: buildMaterialApp(context),
    );
  }

  MaterialApp buildMaterialApp(BuildContext context) {
    return MaterialApp(
      title: "Restaurans",
      theme: ThemeData(
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.orange,
              onPrimary: Colors.black,
              secondary: Colors.green,
            ),
        appBarTheme: const AppBarTheme(elevation: 0),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
        ),
      ),
      navigatorKey: navigatorKey,
      initialRoute: "/",
      routes: {
        '/': (context) => const MenuPage(),
        "/search_page": (context) => const SearchPage(),
        "/setings_page": (context) => const SettingsPage(),
        "/details_page": (context) => DetailRestauransPage(
              id: ModalRoute.of(context)?.settings.arguments as String,
            )
      },
    );
  }
}
