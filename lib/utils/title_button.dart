import 'package:flutter/material.dart';

class TitleButton extends StatefulWidget {
  const TitleButton({Key? key}) : super(key: key);

  @override
  _TitleButtonState createState() => _TitleButtonState();
}

class _TitleButtonState extends State<TitleButton> {
  final _textController = TextEditingController(text: "Trip to Nove Mlyny");

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextField(
                controller: _textController,
                onChanged: (text) {
                  _textController.text = text;
                },
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Icon(
                Icons.content_copy,
                color: Colors.grey,
                // size: 30.0,
              ),
            ],
          ),
          style: TextButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            // backgroundColor: Colors.white,
            padding: EdgeInsets.all(20),
            // textStyle:
          ),
          onPressed: () {},
        ));
  }
}
