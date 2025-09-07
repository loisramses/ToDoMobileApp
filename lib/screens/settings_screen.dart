import 'package:flutter/material.dart';
import 'package:todo_app/widgets/cards/about_card.dart';
import 'package:todo_app/widgets/cards/account_card.dart';
import 'package:todo_app/widgets/cards/notifications_card.dart';
import 'package:todo_app/widgets/cards/preferences_card.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            spacing: 20,
            children: [
              AccountCard(),
              PreferencesCard(),
              NotificationsCard(),
              AboutCard()
            ],
          ),
        ),
      ),
    );
  }
}
