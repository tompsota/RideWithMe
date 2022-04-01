import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  String placeholder;
  bool isPassword;

  InputField({Key? key, required this.placeholder, required this.isPassword}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      shadowColor: Colors.blue,
      child: TextFormField(
        obscureText: isPassword,
        autofocus: false,
        decoration: InputDecoration(
          hintText: placeholder,
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0)),
          focusedBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.transparent, width: 3.0)),
        ),
      ),
    );
  }
}
