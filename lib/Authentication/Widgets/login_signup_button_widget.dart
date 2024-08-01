import 'package:flutter/material.dart';

Widget loginAndSignUpButtonWidget(
  String title,
  VoidCallback buttonAction,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
    child: GestureDetector(
      onTap: buttonAction, // this will dynamic for each button,
      child: Container(
        height: 55,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
    ),
  );
}
