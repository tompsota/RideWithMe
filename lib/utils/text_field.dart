import 'package:flutter/material.dart';

Material InputField(String placeholder, bool isPassword) {
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
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          enabledBorder:
              OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.teal, width: 3.0))),
    ),
  );
}
