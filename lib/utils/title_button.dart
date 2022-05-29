import 'package:flutter/material.dart';

class TitleButton extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<String> callback;
  final TextEditingController textController;

  TitleButton({Key? key, required this.isEnabled, required this.callback, required this.textController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
          enabled: isEnabled,
          controller: textController,
          onFieldSubmitted: (text) {
            textController.text = text;
            callback(text);
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            suffixIcon: isEnabled ? Icon(Icons.edit) : null,
          ),
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
        ));
  }
}
