import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preference_provider.dart';
import '../providers/scedhuling_provider.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/platform_widgets.dart';

class SettingsPage extends StatelessWidget {
  static const String settingsText = 'Settings_page';
  const SettingsPage({Key? key}) : super(key: key);

  Widget _buildList(BuildContext context) {
    return Consumer<PreferenceProvider>(
      builder: (context, provider, child) {
        return ListView(
          children: [
            Material(
              child: ListTile(
                title: const Text('Dark Theme'),
                trailing: Switch.adaptive(
                  value: false,
                  onChanged: (value) => customDialog(context),
                ),
              ),
            ),
            Material(
              child: ListTile(
                title: const Text('Scheduling Notif restaurants'),
                trailing: Consumer<SchedulingProvider>(
                  builder: (context, scheduled, _) {
                    return Switch.adaptive(
                      value: provider.isDailyNotifActive,
                      onChanged: (value) async {
                        if (Platform.isIOS) {
                          customDialog(context);
                        } else {
                          scheduled.scheduledrest(value);
                          provider.enableDailyNotif(value);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(settingsText),
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(settingsText),
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
