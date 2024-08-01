import 'package:flutter/material.dart';

class ConstantFunctions {
  static showErrorDialog(
      String message, String topMessage, IconData icon, context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              elevation: 30,
              icon: Icon(
                icon,
                color: Colors.red,
              ),
              title:
                  Align(alignment: Alignment.center, child: Text(topMessage)),
              content: Text(
                message,
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Color(0xFF345FB4)),
                    ))
              ]);
        });
  }
  //.....................................//
}
