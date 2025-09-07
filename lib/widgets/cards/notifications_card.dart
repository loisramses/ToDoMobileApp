import 'package:flutter/material.dart';

class NotificationsCard extends StatefulWidget {
  const NotificationsCard({super.key});

  @override
  State<NotificationsCard> createState() => _NotificationsCardState();
}

class _NotificationsCardState extends State<NotificationsCard> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notifications',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Card(
          color: Colors.grey.shade700,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Notifications Settings',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onTap: () {
                  // TODO
                  print('tapped notifications');
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
