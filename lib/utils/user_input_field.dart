import 'package:flutter/material.dart';

class UserInputField extends StatefulWidget {
  UserInputField({Key? key, required this.initialValue ,required this.callback}) : super(key: key);

  final initialValue;
  final callback;

  @override
  _UserInputFieldState createState() => _UserInputFieldState();
}

class _UserInputFieldState extends State<UserInputField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialValue;
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Add link to your ride",
            focusColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            prefixIcon: Icon(Icons.add_link),
            suffixIcon: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _controller.clear();
                widget.callback("");
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
            _controller.text = value;
            widget.callback(value);
          },
        ),
      ),
    );
  }
}
