import 'package:flutter/material.dart';
import 'package:lawyers_application/Utilities/utility.dart';

Widget reuseContainer(
    {required String name,
    required String value,
    required double height,
    required BuildContext context,
    required double width}) {
  return Container(
    height: Constants.screenHeight(context) * height,
    width: Constants.screenWidth(context) * width,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadiusDirectional.all(
        Radius.circular(8),
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w400,
            fontSize: 17,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.w400,
            fontSize: 17,
          ),
        ),
      ],
    ),
  );
}
