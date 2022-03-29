import 'package:flutter/material.dart';

TextButton SubmitButton(BuildContext context, String value) {
  return TextButton(
    child: Text(
      value,
      style: TextStyle(fontSize: 16.0),
    ),
    style: TextButton.styleFrom(
      primary: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 40),
      minimumSize: Size(100, 55),
      // textStyle:
    ),
    onPressed: () {},
  );
}
