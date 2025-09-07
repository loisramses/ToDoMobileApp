import 'package:flutter/material.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account',
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
                  'Account Details',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                onTap: () {
                  // TODO
                  print('tapped account');
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
