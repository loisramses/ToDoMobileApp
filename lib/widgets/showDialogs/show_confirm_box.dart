import 'package:flutter/material.dart';

Future<dynamic> showConfirmBox({
  required BuildContext context,
  required String title,
  required String confirmationText,
  required VoidCallback onPressed,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.grey.shade300,
        title: Center(child: Text(title)),
        content: Text(confirmationText),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
