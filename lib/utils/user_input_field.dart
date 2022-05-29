import 'package:flutter/material.dart';

class UserInputField extends StatelessWidget {
  UserInputField({Key? key, required this.callback, required this.controller}) : super(key: key);

  final callback;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Add link to your ride",
            focusColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: Icon(Icons.add_link),
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                controller.clear();
                callback("");
              },
            ),
            fillColor: Colors.white,
            filled: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 3.0)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0), borderSide: BorderSide(color: Colors.transparent, width: 3.0)),
          ),
          onSubmitted: (value) {
            controller.text = value;
            callback(value);
          },
        ),
      ),
    );
  }
}
