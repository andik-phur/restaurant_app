import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import '../data/api_restaurant/api_restaurants.dart';
import '../main.dart';
import 'notif_helper.dart';
import 'package:http/http.dart' as http;

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    if (kDebugMode) {
      print('Alarm fired!');
    }
    final NotificationHelper notificationHelper = NotificationHelper();
    var result = await ApiServices(http.Client()).getList();
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
