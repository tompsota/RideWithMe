import 'package:flutter/material.dart';

class TitleButton extends StatefulWidget {
  bool isEnabled;

  TitleButton({Key? key, required this.isEnabled}) : super(key: key);

  @override
  _TitleButtonState createState() => _TitleButtonState();
}

class _TitleButtonState extends State<TitleButton> {
  final _textController = TextEditingController(text: "Trip to Nove Mlyny");

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          enabled: widget.isEnabled,
          controller: _textController,
          onFieldSubmitted: (text) {
            _textController.text = text;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: widget.isEnabled ? Icon(Icons.edit) : null,
          ),
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
        ));
  }
}
