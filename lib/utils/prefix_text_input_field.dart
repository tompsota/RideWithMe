import 'package:flutter/material.dart';

class PrefixTextInputField extends StatefulWidget {
  PrefixTextInputField({Key? key, required this.initialValue, required this.controller, required this.mediaIcon}) : super(key: key);

  final initialValue;
  final TextEditingController controller;
  final IconData mediaIcon;

  @override
  _PrefixTextInputFieldState createState() => _PrefixTextInputFieldState();
}

class _PrefixTextInputFieldState extends State<PrefixTextInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: TextField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: "Add your username",
            focusColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            // contentPadding: EdgeInsets.only(top: 15),
            prefixIcon: Icon(widget.mediaIcon),
            prefixText: widget.initialValue,
            prefixStyle: TextStyle(color: Colors.grey),
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                widget.controller.text = " ";
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
            widget.controller.text = value.trim();
            // widget.callback(value);
          },
        ),
      ),
    );
  }
}
