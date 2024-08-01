// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget(
      {super.key,
      required this.controller,
      this.onChanged,
      this.suffixIcon,
      required this.hint,
      required this.obscureText,
      this.prefixIcon,
      this.maxLines,
      this.keyboardType,
      this.textInputAction,
      this.errorText});

  TextEditingController controller;
  var onChanged;
  var suffixIcon;
  String hint;
  bool obscureText;
  IconData? prefixIcon;
  var maxLines;
  var keyboardType;
  var textInputAction;
  var errorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(30),
        shadowColor: Colors.grey,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.always,
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          textDirection: TextDirection.ltr,
          obscureText: obscureText,
          cursorColor: const Color(0xFF6789CA),
          onChanged: onChanged,
          decoration: InputDecoration(
            errorText: errorText,
            contentPadding: const EdgeInsets.only(left: 10, bottom: 5),
            border: InputBorder.none,
            suffixIcon: suffixIcon,
            hintText: hint,
            prefixIcon: Icon(prefixIcon),
          ),
        ),
      ),
    );
  }
}
