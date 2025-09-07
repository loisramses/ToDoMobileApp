import 'package:flutter/material.dart';

class AboutCard extends StatefulWidget {
  const AboutCard({super.key});

  @override
  State<AboutCard> createState() => _AboutCardState();
}

class _AboutCardState extends State<AboutCard> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
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
                  'About App',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'TodoApp',
                    applicationVersion: '1.0.0',
                    children: [
                      Text('A simple and effective task management app.')
                    ],
                  );
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
