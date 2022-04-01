import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  VoidCallback callback;
  String value;

  SubmitButton({Key? key, required this.value, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      onPressed: callback,
    );
  }
}
