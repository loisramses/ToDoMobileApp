import 'package:flutter/material.dart';

class PreferencesCard extends StatefulWidget {
  const PreferencesCard({super.key});

  @override
  State<PreferencesCard> createState() => _PreferencesCardState();
}

class _PreferencesCardState extends State<PreferencesCard> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preferences',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Card(
          color: Colors.grey.shade700,
          child: Column(
            children: [
              SwitchListTile(
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                  });
                },
                secondary: Icon(
                  isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white,
                ),
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              ListTile(
                title: Text(
                  'Language',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(
                  'English',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(
                  Icons.language,
                  color: Colors.white,
                ),
                onTap: () {
                  // TODO
                  print('tapped language');
                },
              ),
              Divider(
                color: Colors.grey,
                height: 1,
              ),
              ListTile(
                title: Text(
                  'Font Weight',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(
                  Icons.font_download,
                  color: Colors.white,
                ),
                onTap: () {
                  // TODO
                  print('tapped font');
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
