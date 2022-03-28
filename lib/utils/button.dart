import 'package:flutter/material.dart';

TextButton SubmitButton(String value) {
  return TextButton(
    child: Text(
      value,
      style: TextStyle(fontSize: 16.0),
    ),
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Colors.teal,
      padding: EdgeInsets.symmetric(horizontal: 40),
      // textStyle:
    ),
    onPressed: () {},
  );
}
